$PBExportHeader$w_ma011_art_doc_tecnica.srw
forward
global type w_ma011_art_doc_tecnica from w_abc_master_smpl
end type
end forward

global type w_ma011_art_doc_tecnica from w_abc_master_smpl
integer width = 3429
integer height = 1060
string title = "Documentación Tecnica (MA011)"
string menuname = "m_abc_master_smpl"
end type
global w_ma011_art_doc_tecnica w_ma011_art_doc_tecnica

type variables

end variables

on w_ma011_art_doc_tecnica.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_ma011_art_doc_tecnica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;Long 	 ll_inicio,ll_final
String ls_cod_art,ls_doc_tec_tipo
dw_master.Accepttext()
// Verifica que campos son requeridos y tengan valores
ll_final = dw_master.Rowcount()

FOR ll_inicio = 1 TO ll_final

	IF Isnull(dw_master.Object.cod_art[ll_inicio]) OR Trim(dw_master.Object.cod_art[ll_inicio]) = '' THEN
		Messagebox('Aviso','Ingrese Algun Codigo de Articulo')
		ib_update_check = FALSE
		dw_master.SetRow(ll_inicio)
		dw_master.SelectRow(0,FALSE)
		dw_master.SelectRow(ll_inicio, TRUE)
		dw_master.SetColumn('cod_art')		
		Return
	ELSE
		ib_update_check = TRUE
	END IF
	
	IF Isnull(dw_master.Object.doc_tec_tipo[ll_inicio]) OR Trim(dw_master.Object.doc_tec_tipo[ll_inicio]) = '' THEN
		Messagebox('Aviso','Ingrese Algun Tipo de Documento')
		ib_update_check = FALSE		
		dw_master.SetRow(ll_inicio)		
		dw_master.SelectRow(0,FALSE)
		dw_master.SelectRow(ll_inicio, TRUE)
		dw_master.SetColumn('doc_tec_tipo')
		Return
	ELSE
		ib_update_check = TRUE
	END IF
	
	
NEXT

dw_master.of_set_flag_replicacion( )

end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)    

//Help
ii_help = 15
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma011_art_doc_tecnica
integer x = 0
integer y = 0
integer width = 3342
integer height = 668
string dataobject = "d_abc_art_doc_tecnica_tbl"
end type

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
Long   ll_count
String ls_null,ls_nom_articulo
Setnull(ls_null)
CHOOSE CASE dwo.name
		 CASE 'cod_art'
			
				SELECT Count(*),nom_articulo
				INTO   :ll_count,:ls_nom_articulo
				FROM	 ARTICULO 
				WHERE  COD_ART = :data ;
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Debe Ingresar Un Articulo Valido')
					This.Object.cod_art[row] = ''
					Return 1
				ELSE
					This.Object.articulo_nom_articulo[row] = ls_nom_articulo
				END IF
				
		 CASE	'doc_tec_tipo'
			
//				IF of_val_duplicado('doc_tec_tipo',data) = FALSE THEN
//					Messagebox('Aviso','Registro ya Ha sido Ingresado')
//					This.Object.doc_tec_tipo[row] = ls_null
//					
//					Return 1
//				END IF
//				
END CHOOSE

end event

event dw_master::doubleclicked;call super::doubleclicked;str_seleccionar lstr_seleccionar
String	ls_Path, ls_File, ls_Type, ls_Mask, ls_arch,ls_name,ls_prot
Integer	li_Pos,li_pos_file,li_result



CHOOSE CASE dwo.name
		 CASE	'cod_art'
				ls_name = dwo.name
				ls_prot = this.Describe( ls_name + ".Protect")

				if ls_prot = '1' then    //protegido 
					return
				end if
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT COD_ART 		 AS CODIGO,' &
												+'			NOM_ARTICULO AS DESCRIPCION,' &
												+'			UND AS UNIDAD '&
												+'FROM   ARTICULO '
									  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_art',lstr_seleccionar.param1[1])
					Setitem(row,'articulo_nom_articulo',lstr_seleccionar.param2[1])
				END IF

		 CASE 'descripcion'
				ls_Type = "*.doc"
				ls_Mask = "Archivos Doc (*.doc),*.doc"
	
				If GetFileOpenName("Selecione Documento", ls_Path, ls_File, &
			   							ls_Type, ls_Mask) = 1 Then
											
					li_Pos = Pos(ls_Path, ls_File)
					ls_Path = Left(ls_Path, (li_Pos - 1))
					
					li_pos_file = Pos(ls_file,' ')
					IF li_pos_file > 0 THEN
						Messagebox('Aviso','Debe Grabar El documento sin Espacios En Blanco')
						Return
					END IF

					This.SetItem(row,'descripcion',Trim(ls_Path + ls_file))
					
					IF Len(ls_file) > 0 THEN
						ii_update = 1
					END IF
					
				End If
			Case 'p_fileopen'
					ls_arch = dw_master.Object.descripcion[row]
					IF Isnull(ls_arch) OR Trim(ls_arch) = '' THEN 
						Messagebox('Aviso','Debe Ingresar Algun Archivo')
						Return
					ELSE
						ls_path = 'C:\Archivos de programa\Microsoft Office\Office\WINWORD.EXE '+ls_arch
						li_result = Run(ls_path, Normal!)
						
						IF li_result = -1 THEN
							ls_path = 'C:\Archivos de programa\Accesorios\WORDPAD.EXE '+ls_arch
							li_result = Run(ls_path, Normal!)
						END IF
					END IF
					
					

END CHOOSE


end event

