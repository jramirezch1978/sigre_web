$PBExportHeader$w_rh012_abc_tipo_trabajador.srw
forward
global type w_rh012_abc_tipo_trabajador from w_abc_master_smpl
end type
end forward

global type w_rh012_abc_tipo_trabajador from w_abc_master_smpl
integer width = 3995
integer height = 1340
string title = "(RH012) Tipos de Trabajadores"
string menuname = "m_master_simple"
end type
global w_rh012_abc_tipo_trabajador w_rh012_abc_tipo_trabajador

on w_rh012_abc_tipo_trabajador.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh012_abc_tipo_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;//dw_master.of_column_protect('tipo_trabajador')
String ls_protect
ls_protect=dw_master.Describe("tipo_trabajador.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('tipo_trabajador')
END IF
end event

event ue_update_pre;call super::ue_update_pre;string ls_desc_tipo
int li_row 
li_row = dw_master.GetRow()

If li_row > 0 Then 
	ls_desc_tipo = Trim(dw_master.GetItemString(li_row,"desc_tipo_tra"))

	If len(ls_desc_tipo) = 0 or isnull(ls_desc_tipo) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validación","Ingrese una DESCRIPCION")
		dw_master.SetColumn("desc_tipo_tra")
		dw_master.SetFocus()
	End if	
Else 
	return 
End if	

dw_master.of_set_flag_replicacion( )
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh012_abc_tipo_trabajador
integer width = 3945
integer height = 1144
string dataobject = "d_tipo_trabajador_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;Long	 ll_nro_libro,ll_count
String ls_tipo_trab, ls_col, desc_libro
Integer li_nro_libro

ls_col = trim(string(dwo.name))

choose case ls_col
		 case 'tipo_trabajador'
				ls_tipo_trab = trim(dw_master.GetText())
			
				if len(ls_tipo_trab) <> 3 THen
					Messagebox("Sistema de validacion","El Tipo de Trabajador es "+&
					           " de 3 Digitos")
			    	dw_master.SetColumn("tipo_trabajador")
					dw_master.setfocus()
		   	   Return 1	
			   End if	
				
		 case 'libro_prov_cts','libro_planilla'
				ll_nro_libro = Long(data)
				
				select count(*) into :ll_count from cntbl_libro
				 where nro_libro = :ll_nro_libro ;
				
				if ll_count > 0 then
					Messagebox('Aviso','Nro de Libro No Existe , Verifique!')
					Return 1
				end if 
		 case 'cnta_prsp_afec_cts'
				select count(*) into :ll_count from presupuesto_cuenta where cnta_prsp = :data and flag_estado = '1' ;
				
				if ll_count = 0 then
					Messagebox('Aviso','Cuenta Presupuestal No Existe , Verifique!')
					Return 1
    			end if 
		 case 'cnta_ctbl_cts_cargo','cnta_ctbl_cts_abono'
				select Count(*) into :ll_count from cntbl_cnta where cnta_ctbl = :data and flag_estado = '1' ;
				
				if ll_count = 0 then
					Messagebox('Aviso','Nro de Libro No Existe , Verifique!')
					Return 1
    			end if 
				
				

				
End choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_trabajador.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;str_seleccionar lstr_seleccionar
String ls_name

choose case dwo.name
		
		 case 'cnta_prsp_afec_cts'
				 lstr_seleccionar.s_seleccion = 'S'
             lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP   AS CODIGO,'&
			  											  +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
		  		   									  +'FROM PRESUPUESTO_CUENTA '&
														  +'WHERE PRESUPUESTO_CUENTA.FLAG_ESTADO = '+"'"+'1'+"'"
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,'cnta_prsp_afec_cts',lstr_seleccionar.param1[1])
					ii_update = 1				   
			   END IF	
		 case 'libro_prov_cts','libro_planilla'
				ls_name = dwo.name
				
				 lstr_seleccionar.s_seleccion = 'S'
             lstr_seleccionar.s_sql = 'SELECT CNTBL_LIBRO.NRO_LIBRO  AS CODIGO,'&
			  											  +'CNTBL_LIBRO.DESC_LIBRO AS DESCRIPCION '&
		  		   									  +'FROM CNTBL_LIBRO '
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,ls_name,lstr_seleccionar.paramdc1[1])
					ii_update = 1				   
			   END IF	
			
		 case 'cnta_ctbl_cts_cargo','cnta_ctbl_cts_abono'
				ls_name = dwo.name
				
				 lstr_seleccionar.s_seleccion = 'S'
             lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL  AS CUENTA_CONTABLE,'&
			  											  +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION '&
		  		   									  +'FROM CNTBL_CNTA '&
														  +'WHERE CNTBL_CNTA.FLAG_ESTADO = '+"'"+'1'+"'"
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,ls_name,lstr_seleccionar.param1[1])
					ii_update = 1				   
			   END IF				
		 
end choose

end event

