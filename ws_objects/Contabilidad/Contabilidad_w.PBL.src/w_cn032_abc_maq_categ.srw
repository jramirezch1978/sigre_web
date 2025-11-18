$PBExportHeader$w_cn032_abc_maq_categ.srw
forward
global type w_cn032_abc_maq_categ from w_abc_mastdet_smpl
end type
end forward

global type w_cn032_abc_maq_categ from w_abc_mastdet_smpl
integer width = 2738
integer height = 1788
string title = "Categoria de maquinas (CN032)"
string menuname = "m_abc_mastdet_smpl"
end type
global w_cn032_abc_maq_categ w_cn032_abc_maq_categ

on w_cn032_abc_maq_categ.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_cn032_abc_maq_categ.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("categoria.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("categoria")
END IF

ls_protect=dw_detail.Describe("categoria.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("categoria")
END IF
ls_protect=dw_detail.Describe("cod_maquina.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_maquina")
END IF
end event

event ue_open_pre();call super::ue_open_pre;of_position_window(20,20)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn032_abc_maq_categ
integer x = 0
integer y = 0
integer width = 2665
integer height = 684
string dataobject = "d_abc_maq_categ_costeo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
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
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE
end event

event dw_master::itemchanged;call super::itemchanged;String ls_codigo, ls_desc_cencos
Long ll_count

IF Getrow() = 0 THEN Return

CHOOSE CASE dwo.name
	CASE 'cencos'
		ls_codigo = data 
		  
		SELECT count(*)
		INTO :ll_count
		FROM centros_costo
		WHERE cencos = :ls_codigo ;
		
		IF ll_count > 0 THEN
			SELECT desc_cencos
			INTO :ls_desc_cencos
			FROM centros_costo
			WHERE cencos = :ls_codigo ;
			
			Setitem( row, 'desc_cencos', ls_desc_cencos )
		END IF 
END CHOOSE

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;// Genera asiento
SetItem(al_row, 'flag_asiento','G')
// Estado activo
SetItem(al_row, 'flag_estado','1')
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)



end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn032_abc_maq_categ
integer y = 724
integer width = 2661
integer height = 860
string dataobject = "d_maq_categoria_det_tbl"
boolean hscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo, ls_desc_maq, ls_flag_estado
Long ll_count

IF Getrow() = 0 THEN Return

CHOOSE CASE dwo.name
	CASE 'cod_maquina'
		ls_codigo = data 
		  
		SELECT count(*)
		INTO :ll_count
		FROM maquina
		WHERE cod_maquina = :ls_codigo ;
		
		IF ll_count > 0 THEN
			SELECT desc_maq, flag_estado
			INTO :ls_desc_maq, :ls_flag_estado
			FROM maquina
			WHERE cod_maquina = :ls_codigo ;
			
			Setitem( row, 'desc_maq', ls_desc_maq )
			Setitem( row, 'flag_estado', ls_flag_estado )
		END IF 
END CHOOSE

end event

event dw_detail::doubleclicked;call super::doubleclicked;
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		CASE 'cod_maquina'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO, '&
														 +'MAQUINA.DESC_MAQ AS DESCRIPCION, '&
														 +'MAQUINA.FLAG_ESTADO AS ESTADO '&
														 +'FROM MAQUINA ' &
														 +'WHERE FLAG_ESTADO = 1'
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
					Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
					Setitem(row,'flag_estado',lstr_seleccionar.param3[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

