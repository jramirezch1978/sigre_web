$PBExportHeader$w_ma017_grupo_cencos.srw
forward
global type w_ma017_grupo_cencos from w_abc_mastdet_smpl
end type
end forward

global type w_ma017_grupo_cencos from w_abc_mastdet_smpl
integer width = 1847
string title = "Grupo de centros de costos (MA017)"
string menuname = "m_abc_mastdet_smpl"
end type
global w_ma017_grupo_cencos w_ma017_grupo_cencos

on w_ma017_grupo_cencos.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_ma017_grupo_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(100,100)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ma017_grupo_cencos
integer width = 1769
string dataobject = "d_abc_centros_costo_grupo_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1 	      	 // columnas que se pasan al detalle

//idw_mst  = 				// dw_master

end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ma017_grupo_cencos
integer x = 5
integer width = 1769
string dataobject = "d_abc_centros_costo_grupo_det_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2	
ii_rk[1] = 1 	      	// columnas que recibimos del master

end event

event dw_detail::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cencos'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO,'&
						      				+'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
									 		   +'FROM CENTROS_COSTO '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
				END IF
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;Long ll_registro
String ls_desc_cencos



Accepttext()

CHOOSE CASE dwo.name

		 CASE 'cencos'
				select count(*), desc_cencos 
				  into :ll_registro, :ls_desc_cencos
				  from centros_costo 
				 where cencos = :data 
				group by desc_cencos;

			if ll_registro = 0 then
				SetNull(ls_desc_cencos)
				messagebox('Aviso', 'Centro de costo no existe')
				This.Setitem(row,dwo.name,'')	
				This.Setitem(row,'desc_cencos',ls_desc_cencos)	
				Return 1
			else
				This.Setitem(row,'desc_cencos',ls_desc_cencos)	
				Return 2
			end if

END CHOOSE



end event

event dw_detail::ue_insert_pre(long al_row);Long ll_row, ll_item
String ls_grupo

ll_row = dw_master.Getrow()
ls_grupo = dw_master.GetItemString( ll_row, 'grupo' )

dw_detail.SetItem(al_row, 'grupo', ls_grupo )
dw_detail.SetItem(al_row, 'item' , al_row   )

end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

