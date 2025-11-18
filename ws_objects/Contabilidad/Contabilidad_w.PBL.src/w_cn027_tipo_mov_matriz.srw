$PBExportHeader$w_cn027_tipo_mov_matriz.srw
forward
global type w_cn027_tipo_mov_matriz from w_abc_master_smpl
end type
end forward

global type w_cn027_tipo_mov_matriz from w_abc_master_smpl
integer width = 3662
integer height = 1796
string title = "Matrices Contables por Moviemto de Almacen (CN027)"
string menuname = "m_abc_master_smpl"
end type
global w_cn027_tipo_mov_matriz w_cn027_tipo_mov_matriz

on w_cn027_tipo_mov_matriz.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn027_tipo_mov_matriz.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_mov.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_mov")
END IF
ls_protect=dw_master.Describe("item.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("item")	
END IF
ls_protect=dw_master.Describe("grp_cntbl.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("grp_cntbl")
END IF
ls_protect=dw_master.Describe("cnta_prsp.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cnta_prsp")
END IF

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn027_tipo_mov_matriz
integer x = 0
integer y = 184
integer width = 3589
integer height = 1424
string dataobject = "d_tipo_mov_matriz_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw
ii_ck[4] = 4				// columnas de lectura de este dw

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
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
		 CASE 'tipo_mov'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ARTICULO_MOV_TIPO.TIPO_MOV AS TIPO_MOV, '&
														 +'ARTICULO_MOV_TIPO.DESC_TIPO_MOV AS DESC_TIPO_MOV '&
														 +'FROM ARTICULO_MOV_TIPO WHERE ARTICULO_MOV_TIPO.FLAG_CONTABILIZA= '+"'"+'1'+"'"
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'tipo_mov',lstr_seleccionar.param1[1])
					Setitem(row,'desc_tipo_mov',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'grp_cntbl'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT GRUPO_CONTABLE.GRP_CNTBL AS GRP_CNTBL, '&
														 +'GRUPO_CONTABLE.DESC_GRP_CNTBL AS DESCRIP '&
														 +'FROM GRUPO_CONTABLE ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'grp_cntbl',lstr_seleccionar.param1[1])
					Setitem(row,'desc_tipo_mov',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'matriz'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MATRIZ_CNTBL_FINAN.MATRIZ AS MATRIZ, '&
														 +'MATRIZ_CNTBL_FINAN.DESCRIPCION AS DESCRIPCION '&
														 +'FROM MATRIZ_CNTBL_FINAN ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'matriz',lstr_seleccionar.param1[1])
					Setitem(row,'desc_matriz',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

		 CASE 'cnta_prsp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cnta_prsp',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;// Ventanas de ayuda
String ls_descrip
Long ll_ubica
IF Getrow() = 0 THEN Return

CHOOSE CASE dwo.name
		 CASE 'tipo_mov'

			select desc_tipo_mov into :ls_descrip
			from articulo_mov_tipo
			where tipo_mov = :data ;
			
			this.SetItem( row, 'desc_tipo_mov', ls_descrip)
			
			ii_update = 1
			
		 CASE 'matriz'

			select descripcion into :ls_descrip
			from matriz_cntbl_finan
			where matriz = :data ;
			
			this.SetItem( row, 'desc_matriz', ls_descrip)
			ii_update = 1

		 CASE 'cnta_prsp'
			
			select descripcion into :ls_descrip
			from presupuesto_cuenta
			where cnta_prsp = :data ;

			this.SetItem( row, 'desc_cnta_prsp', ls_descrip)
			ii_update = 1

END CHOOSE

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

