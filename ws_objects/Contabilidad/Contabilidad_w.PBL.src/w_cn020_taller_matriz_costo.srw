$PBExportHeader$w_cn020_taller_matriz_costo.srw
forward
global type w_cn020_taller_matriz_costo from w_abc_master_smpl
end type
end forward

global type w_cn020_taller_matriz_costo from w_abc_master_smpl
integer width = 2565
integer height = 1476
string title = "Costo Horario de Talleres (CN020)"
string menuname = "m_abc_master_smpl"
end type
global w_cn020_taller_matriz_costo w_cn020_taller_matriz_costo

on w_cn020_taller_matriz_costo.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn020_taller_matriz_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre();call super::ue_update_pre;//--Verificación y Asignación dw_detdet 
if f_row_Processing( dw_master, "tabular") <> true then 
 ib_update_check = False 
 return 
else 
 ib_update_check = True 
end if 
end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(20,20)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn020_taller_matriz_costo
integer x = 0
integer y = 0
integer width = 2523
integer height = 1288
string dataobject = "d_taller_matriz_costo_tbl"
boolean hscrollbar = false
end type

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
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO, '&
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

event dw_master::itemchanged;call super::itemchanged;
String ls_cencos, ls_desc_cencos
Long ll_found
ll_found = 0
CHOOSE CASE dwo.name
		 CASE 'cencos'
			ls_cencos = data
			
			select count(*), desc_cencos into :ll_found, :ls_desc_cencos &
			from centros_costo where cencos = :ls_cencos 
			group by desc_cencos ;
			
			if ll_found = 0 then
				messagebox('Aviso', 'Centro de costo no existe')
				return 1
			end if
			//Setitem(row, 'cencos', ls_cencos)
			Setitem(row,'desc_cencos', ls_desc_cencos)
			
			ii_update = 1

END CHOOSE

end event

event dw_master::ue_insert_pre(long al_row);Long ll_ano, ll_mes
String ls_cod_moneda

IF month( today() ) = 1 then
	ll_ano = year( today() ) - 1
	ll_mes = 12
ELSE
	ll_ano = year( today() )
	ll_mes = month (today() ) - 1
END IF

select cod_soles into :ls_cod_moneda from logparam where logparam reckey='1' ;
SetItem( al_row, 'ano', ll_ano )
SetItem( al_row, 'mes', ll_mes )
SetItem( al_row, 'cod_moneda', ls_cod_moneda )
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

