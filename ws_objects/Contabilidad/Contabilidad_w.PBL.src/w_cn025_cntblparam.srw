$PBExportHeader$w_cn025_cntblparam.srw
forward
global type w_cn025_cntblparam from w_abc_master
end type
end forward

global type w_cn025_cntblparam from w_abc_master
integer width = 3493
integer height = 1784
string title = "Parametros de Contabilidad (CN025)"
string menuname = "m_abc_master_smpl"
end type
global w_cn025_cntblparam w_cn025_cntblparam

on w_cn025_cntblparam.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn025_cntblparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_master.Retrieve()
//of_position_window(20,20)       			// Posicionar la ventana en forma fija

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master`dw_master within w_cn025_cntblparam
integer x = 0
integer y = 0
integer width = 3442
integer height = 1600
string dataobject = "d_cntblparam_ff"
end type

event dw_master::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cnta_debe_tranf'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_debe_tranf',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_haber_tranf'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_haber_tranf',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_debe_x_fact'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_debe_x_fact',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_haber_x_fact'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_haber_x_fact',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_debe_trab_activar'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_debe_trab_activar',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_haber_trab_activar'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_haber_trab_activar',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;String ls_reckey
ls_reckey='1'
this.SetItem(al_row, 'reckey', ls_reckey)
end event

event dw_master::itemchanged;call super::itemchanged;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_cuenta
Long ll_count

CHOOSE CASE dwo.name
		 CASE 'cnta_debe_tranf'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
		 CASE 'cnta_haber_tranf'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
		 CASE 'cnta_debe_x_fact'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
		 CASE 'cnta_haber_x_fact'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
		 CASE 'cnta_debe_trab_activar'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
		 CASE 'cnta_haber_trab_activar'
				ls_cuenta = data
				select count() 
				into :ll_count
				from cntbl_cnta
				where cnta_ctbl=:data ;
				IF ll_count=0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					setnull(ls_cuenta)
					//This.SetItem(row, 'cnta_debe_transf', ls_cuenta)
				END IF
END CHOOSE
//ii_update = 1
end event

