$PBExportHeader$w_ope028_prod_vs_labores.srw
forward
global type w_ope028_prod_vs_labores from w_abc_master_smpl
end type
end forward

global type w_ope028_prod_vs_labores from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 2725
integer height = 1560
string title = "Productos vs Labores (OPE028)"
string menuname = "m_master_sin_lista"
boolean minbox = false
boolean maxbox = false
end type
global w_ope028_prod_vs_labores w_ope028_prod_vs_labores

on w_ope028_prod_vs_labores.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope028_prod_vs_labores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(150,150)
ii_help = 3           					// help topic


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope028_prod_vs_labores
integer x = 0
integer y = 0
integer width = 2661
integer height = 1296
string dataobject = "d_productos_vs_labores_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot,ls_cod_labor
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_labor'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS LABOR, '&
														 +'LABOR.DESC_LABOR AS DESCRIPCION, '&
														 +'LABOR.UND AS UNIDAD '&
														 +'FROM LABOR WHERE FLAG_ESTADO <>'+"'0'"

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_labor' ,lstr_seleccionar.param1[1])
					Setitem(row,'desc_labor',lstr_seleccionar.param2[1])
					Setitem(row,'und'       ,lstr_seleccionar.param3[1])
					ii_update = 1
				END IF
				
		CASE 'cod_ejecutor'
               ls_cod_labor = dw_master.object.cod_labor[dw_master.GetRow()]
               lstr_seleccionar.s_seleccion = 'S'
               lstr_seleccionar.s_sql = 'SELECT LABOR_EJECUTOR.COD_EJECUTOR AS EJECUTOR ' &
                                               +'FROM LABOR_EJECUTOR '&
                                               +'WHERE COD_LABOR   = '+"'"+ls_cod_labor+"' AND " &
                                               +'      FLAG_ESTADO = '+"'"+'1'+"'"
                                                              OpenWithParm(w_seleccionar,lstr_seleccionar)
                              IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
               IF lstr_seleccionar.s_action = "aceptar" THEN
                   Setitem(row,'cod_ejecutor',lstr_seleccionar.param1[1])
                   this.ii_update = 1
               END IF       				
END CHOOSE




end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
Integer li_count
String  ls_data1,ls_data2,ls_null,ls_cod_labor,ls_cod_ejecutor

SetNull(ls_null)


CHOOSE CASE dwo.name
		 // Busca si centro de costo existe
		 CASE 'cod_labor'
				SELECT desc_labor,und
				  INTO :ls_data1,:ls_data2
				  FROM labor
				 WHERE (cod_labor   = :data ) and
				 		 (flag_estado = '1'	 ) ;
				 
				 if sqlca.sqlcode = 100 then
					 this.object.cod_labor  [row] = ls_null
					 this.object.desc_labor [row] = ls_null
					 this.object.und			[row] = ls_null
				 else
					 this.object.desc_labor [row] = ls_data1
					 this.object.und			[row] = ls_data2
				 end if	

		CASE 'cod_ejecutor'
               ls_cod_labor = this.object.cod_labor[this.GetRow()]
               ls_cod_ejecutor = data
                              SELECT count(*) INTO :li_count
               FROM labor_ejecutor le
               WHERE le.cod_labor         = :ls_cod_labor
                 AND le.cod_ejecutor     = :ls_cod_ejecutor ;
					  
               IF li_count=0 THEN
                   Messagebox('Aviso','Ejecutor no esta configurado para labor')
                   SetNull(ls_null)                                       
						 This.object.cod_ejecutor [row] = ls_null                                      
						 Return 1
               END IF        				 
END CHOOSE

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

