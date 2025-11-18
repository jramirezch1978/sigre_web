$PBExportHeader$w_ope029_productos.srw
forward
global type w_ope029_productos from w_abc_master_smpl
end type
end forward

global type w_ope029_productos from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 3904
integer height = 1704
string title = "Productos de Pesaje (OPE029)"
string menuname = "m_master_sin_lista"
boolean minbox = false
boolean maxbox = false
end type
global w_ope029_productos w_ope029_productos

on w_ope029_productos.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope029_productos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(150,150)
ii_help = 3           					// help topic


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope029_productos
integer x = 0
integer y = 0
integer width = 3840
integer height = 1296
string dataobject = "d_abc_productos_pesaje_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;Long   ll_count
String ls_null

SetNull(ls_null)



Accepttext()

choose case dwo.name
		 case 'cod_clasif'
				select count(*) into :ll_count 
				  from prod_pesaje_clasif
			    where (cod_clasif  = :data) and
				 		 (flag_estado = '1'	) ;
				
				if ll_count = 0 then
					this.object.cod_clasif [row] = ls_null
					Messagebox('Aviso','Codigo de Clasificacion No Existe ,Verifique!')
					Return 1
				end if
				
				
		 case 'cod_art'
				select count(*) into :ll_count
				  from articulo
				 where (cod_art     = :data ) and
				 		 (flag_estado = '1'   ) ;
						  
						  
			   if ll_count = 0 then
					this.object.cod_art [row] = ls_null
					Messagebox('Aviso','Codigo de ARTICULO No Existe ,Verifique!')
					Return 1
				end if
end choose

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
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
	 CASE 'cod_art'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO, '&   
											 +'ARTICULO.DESC_ART AS DESCRIPCION, '&   
											 +'ARTICULO.UND AS UNIDAD '&   
											 +'FROM  ARTICULO '&
											 +'WHERE ARTICULO.FLAG_ESTADO = '+"'"+'1'+"'"

			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				
				Setitem(row,'cod_art',lstr_seleccionar.param1[1])
			
				ii_update = 1
			END IF
			
	 CASE 'cod_clasif'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT PROD_PESAJE_CLASIF.COD_CLASIF AS CODIGO, '&   
											 +'PROD_PESAJE_CLASIF.DESCRIPCION AS DESCRIPCION, '&   
											 +'PROD_PESAJE_CLASIF.IND_DISTRIB AS INDICADOR '&   
											 +'FROM  PROD_PESAJE_CLASIF '&
											 +'WHERE PROD_PESAJE_CLASIF.FLAG_ESTADO = '+"'"+'1'+"'"

			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				
				Setitem(row,'cod_clasif',lstr_seleccionar.param1[1])
			
				ii_update = 1
			END IF
			
END CHOOSE


end event

