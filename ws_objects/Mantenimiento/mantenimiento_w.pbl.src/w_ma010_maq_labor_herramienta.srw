$PBExportHeader$w_ma010_maq_labor_herramienta.srw
forward
global type w_ma010_maq_labor_herramienta from w_abc_master_smpl
end type
end forward

global type w_ma010_maq_labor_herramienta from w_abc_master_smpl
integer width = 3643
integer height = 1336
string title = "Equipos / Maquinas x Labor (MA010)"
string menuname = "m_abc_master_smpl"
end type
global w_ma010_maq_labor_herramienta w_ma010_maq_labor_herramienta

on w_ma010_maq_labor_herramienta.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_ma010_maq_labor_herramienta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion( )
end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)    

//Help
ii_help = 14
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma010_maq_labor_herramienta
integer y = 0
integer width = 3579
integer height = 1128
string dataobject = "d_abc_maq_labor_herramienta_tbl"
end type

event dw_master::itemchanged;Accepttext()
String ls_cod_labor,ls_cod_maquina,ls_cod_art,ls_desc,ls_expresion,ls_null,ls_nom_articulo
long ll_found = 0,ll_count



This.Object.flag [row] = 'S'
SetNULL(ls_null)
ls_cod_labor   = This.Object.cod_labor  	[row]
ls_cod_maquina = This.Object.cod_maquina	[row] 
ls_cod_art	   = This.Object.cod_art		[row]
ls_expresion 	= 'cod_maquina = '+"'"+ls_cod_maquina+"'"+' AND cod_labor = '+"'"+ls_cod_labor  +"'"+' AND cod_art	= '+"'"+ls_cod_art+"'"+' AND flag = '+"'"+'N'+"'"
ll_found 		= dw_master.Find(ls_expresion, 1, dw_master.RowCount())


CHOOSE CASE dwo.name
		 CASE 'cod_maquina'
				SELECT Nvl(DESC_MAQ,'')
				INTO   :ls_desc
				FROM   MAQUINA
				WHERE  COD_MAQUINA = :data ;
				
				IF Isnull(ls_desc) OR Trim(ls_desc) = ''  THEN
					This.Object.cod_maquina [row] = ls_null
					Messagebox('Aviso','Codigo de Maquina No Existe')
					Return 1
				ELSE
					
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Maquina Ya Ha sido considerado dentro de una labor y Herramienta') 						
						This.Object.cod_maquina [row] = ls_null
						Return 1
					ELSE
						This.Object.desc_maq[row] = ls_desc
						This.Object.flag [row] = 'N'
					END IF
				END IF
				
		 CASE 'cod_labor'
			
				SELECT DESC_LABOR 
				INTO	 :ls_desc
				FROM 	 LABOR
				WHERE  COD_LABOR = :data ;

				IF Isnull(ls_desc) OR Trim(ls_desc) = ''  THEN
					This.Object.cod_labor [row] = ls_null
					Messagebox('Aviso','Codigo de Labor No Existe')
					Return 1
				ELSE


	
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Labor Ya Ha sido considerado dentro de una Maquina y Herramienta')
						This.Object.cod_labor [row] = ls_null
						Return 1
					ELSE
						This.Object.desc_labor[row] = ls_desc
						This.Object.flag [row] = 'N'
					END IF
				END IF
				
		 CASE 'cod_art'
			
				SELECT COUNT(*),NOM_ARTICULO
				INTO	 :ll_count,:ls_nom_articulo
		      FROM 	 ARTICULO
				WHERE  COD_ART = :data ;
				
				IF ll_count = 0 THEN
					This.Object.cod_art [row] = ls_null
					Messagebox('Aviso','Codigo de Articulo No Existe')
					Return 1					
				ELSE
	
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Articulo Ya Ha sido considerado dentro de una Maquina y Labor') 						
						This.Object.cod_art [row] = ls_null
						Return 1
					ELSE
						This.Object.nom_articulo [row] = ls_nom_articulo
						This.Object.flag 			 [row] = 'N'
					END IF
				END IF
		
END CHOOSE
								 

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;Accepttext()
String ls_cod_labor,ls_cod_maquina,ls_cod_art
long ll_found = 0
str_seleccionar lstr_seleccionar

CHOOSE CASE dwo.name
		 CASE 'cod_maquina'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO, '&
		      						 +'MAQUINA.DESC_MAQ AS DESCRIPCION, '&     	
										 +'MAQUINA.TIPO_MAQUINA AS TIPO '&     	
							 		   +'FROM MAQUINA '
									  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				IF lstr_seleccionar.s_action = "aceptar" THEN
					
					ls_cod_labor   = This.Object.cod_labor		[row] 
					ls_cod_maquina = lstr_seleccionar.param1	[1] 
					ls_cod_art	   = This.Object.cod_art		[row]
					
					ll_found = dw_master.Find('   cod_maquina = '+"'"+ls_cod_maquina+"'"+&
													  ' AND cod_labor = '+"'"+ls_cod_labor  +"'"+&
													  ' AND cod_art	= '+"'"+ls_cod_art	 +"'"+' ', 1, dw_master.RowCount())
													  
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Maquina Ya Ha sido considerado dentro de una labor y Herramienta') 						
						Return 1
					ELSE
						Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])					
						Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
						ii_update = 1
					END IF
				END IF
				 
		 CASE 'cod_labor'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS CODIGO,'&
		      						 				 +'LABOR.COD_ETAPA AS ETAPA,'&     	
										 				 +'LABOR.DESC_LABOR AS DESCRIPCION,'&     	
														 +'LABOR.UND AS UNIDAD '& 
							 		   		+'FROM LABOR '
									  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				IF lstr_seleccionar.s_action = "aceptar" THEN
					
					ls_cod_labor   = lstr_seleccionar.param1	[1] 
					ls_cod_maquina = This.Object.cod_maquina	[row]
					ls_cod_art	   = This.Object.cod_art		[row]
					
					ll_found = dw_master.Find('   cod_maquina = '+"'"+ls_cod_maquina+"'"+&
													  ' AND cod_labor = '+"'"+ls_cod_labor  +"'"+&
													  ' AND cod_art	= '+"'"+ls_cod_art	 +"'"+' ', 1, dw_master.RowCount())
													  
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Labor Ya Ha sido considerado dentro de una Maquina y Herramienta') 						
						Return 1
					ELSE
						Setitem(row,'cod_labor',lstr_seleccionar.param1[1])					
						Setitem(row,'desc_labor',lstr_seleccionar.param3[1])
						ii_update = 1
					END IF

				END IF
				
		 CASE 'cod_art'		
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO,'&
		      						 				 +'ARTICULO.DESC_ART AS DESCRIPCION,'&     	
										 				 +'ARTICULO.UND AS UNIDAD '&     	
							 		   		+'FROM ARTICULO '
									  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				IF lstr_seleccionar.s_action = "aceptar" THEN
					ls_cod_labor   = This.Object.cod_labor		[row]
					ls_cod_maquina = This.Object.cod_maquina	[row]
					ls_cod_art	   = lstr_seleccionar.param1	[1]
					
					ll_found = dw_master.Find('   cod_maquina = '+"'"+ls_cod_maquina+"'"+&
													  ' AND cod_labor = '+"'"+ls_cod_labor  +"'"+&
													  ' AND cod_art	= '+"'"+ls_cod_art	 +"'"+' ', 1, dw_master.RowCount())
													  
					IF ll_found > 0 THEN
						Messagebox('Aviso','Codigo de Articulo Ya Ha sido considerado dentro de una Maquina y Labor') 						
						Return 1
					ELSE
						Setitem(row,'cod_art',lstr_seleccionar.param1[1])					
						Setitem(row,'nom_articulo',lstr_seleccionar.param2[1])					
						ii_update = 1
					END IF
				END IF
				

END CHOOSE

end event

