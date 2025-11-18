$PBExportHeader$w_cn033_costeo_categoria_maquina.srw
forward
global type w_cn033_costeo_categoria_maquina from w_abc_master_smpl
end type
end forward

global type w_cn033_costeo_categoria_maquina from w_abc_master_smpl
integer width = 2391
integer height = 1628
string title = "Costeo de maquinarias (CN033)"
string menuname = "m_abc_master_smpl"
end type
global w_cn033_costeo_categoria_maquina w_cn033_costeo_categoria_maquina

on w_cn033_costeo_categoria_maquina.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn033_costeo_categoria_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cn033_costeo_categoria_maquina
integer width = 2318
integer height = 1416
string dataobject = "d_abc_costeo_categ_maq_tbl"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw

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
		CASE 'categoria'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQ_CATEGORIA_COSTEO.CATEGORIA AS CATEGORIA, '&
														 +'MAQ_CATEGORIA_COSTEO.DESCRIPCION AS DESCRIPCION, '&
														 +'MAQ_CATEGORIA_COSTEO.CENCOS AS CENCOS '&
														 +'FROM MAQ_CATEGORIA_COSTEO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'categoria',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					Setitem(row,'maq_categoria_costeo_cencos',lstr_seleccionar.param3[1])
					ii_update = 1
				END IF
END CHOOSE

end event

