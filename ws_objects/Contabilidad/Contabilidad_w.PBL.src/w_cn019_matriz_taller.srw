$PBExportHeader$w_cn019_matriz_taller.srw
forward
global type w_cn019_matriz_taller from w_abc_mastdet_smpl
end type
end forward

global type w_cn019_matriz_taller from w_abc_mastdet_smpl
integer width = 3465
integer height = 1640
string title = "Matriz Contable de Talleres (CN019)"
string menuname = "m_abc_mastdet_smpl"
end type
global w_cn019_matriz_taller w_cn019_matriz_taller

on w_cn019_matriz_taller.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_cn019_matriz_taller.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(0,0)
end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cencos.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cencos")
END IF
ls_protect=dw_detail.Describe("cencos.protect")
IF ls_protect='0' THEN
	dw_detail.of_column_protect("cencos")
   dw_detail.of_column_protect("nro_item")
END IF

end event

event resize;// Override
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn019_matriz_taller
integer x = 14
integer y = 36
integer width = 3397
integer height = 412
string dataobject = "d_taller_matriz_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(string(aa_id[1]))
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
		CASE 'nro_libro'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_LIBRO.NRO_LIBRO AS LIBRO, '&
														 +'CNTBL_LIBRO.DESC_LIBRO AS DESCRIPCION '&
														 +'FROM CNTBL_LIBRO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'nro_libro',lstr_seleccionar.paramdc1[1])
					Setitem(row,'desc_libro',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_desc_cencos, ls_desc_libro
Long ll_data, ll_nro_libro, ll_count
Integer li_data

CHOOSE CASE dwo.name
		CASE 'cencos'
			ls_data = GetText()
			select count(*), desc_cencos into :ll_count, :ls_desc_cencos
			from centros_costo where cencos = :ls_data
			group by desc_cencos ;
			if ll_count > 0 then
				Setitem( row, 'desc_cencos', ls_desc_cencos)
				ii_update = 1
		end if
		CASE 'nro_libro'
			ls_data = GetText()
			li_data = Integer( ls_data )
			select count(*), desc_libro into :ll_count, :ls_desc_libro
			from cntb_libro where nro_libro = :li_data
			group by desc_libro;
			if ll_count > 0 then
				Setitem( row, 'desc_libro', ls_desc_libro )
				ii_update = 1
			end if			
END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn019_matriz_taller
integer x = 14
integer y = 492
integer width = 3397
integer height = 928
string dataobject = "d_taller_matriz_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_rk[1] = 1 	      // columnas que recibimos del master
end event

event dw_detail::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		CASE 'cencos_destino'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos_destino',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		CASE 'confin'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN AS CODIGO, '&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION AS DESCRIP '&
														 +'FROM CONCEPTO_FINANCIERO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'confin',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		CASE 'cnta_ctbl_debe'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIP '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl_debe',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		CASE 'cnta_ctbl_haber'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIP '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl_haber',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event dw_detail::ue_insert_pre(long al_row);call super::ue_insert_pre;Long ln_nro_item, ln_row
String ls_cencos
//ln_row = dw_master.GetRow()
ls_cencos = dw_master.GetItemString( dw_master.GetRow(), 'cencos' )

select max(nro_item) into :ln_nro_item from taller_matriz_det where cencos = :ls_cencos;

if isnull(ln_nro_item) then
	ln_nro_item = 10
else
	ln_nro_item = ln_nro_item + 10
end if 
this.SetItem(al_row, 'nro_item', ln_nro_item )
this.SetItem(al_row, 'flag_fin_sec', 'D' )
end event

