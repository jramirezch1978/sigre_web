$PBExportHeader$w_ba100_articulos_basc.srw
forward
global type w_ba100_articulos_basc from w_abc_master_smpl
end type
end forward

global type w_ba100_articulos_basc from w_abc_master_smpl
integer width = 2423
integer height = 1532
string title = "[BA100] Artículos controlados por BASC"
string menuname = "m_abc_master"
boolean maxbox = false
boolean resizable = false
end type
global w_ba100_articulos_basc w_ba100_articulos_basc

type variables
string is_grupobasc
end variables

on w_ba100_articulos_basc.create
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
end on

on w_ba100_articulos_basc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;try 
	is_grupobasc = gnvo_app.of_get_parametro("GRUPO_ART_BASC", "BASC")
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
finally
	/*statementBlock*/
end try

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

//Verificación de Data en Detalle de Documento
IF gnvo_app.of_row_Processing( dw_master ) <> true then	
	dw_master.setFocus( )
	return
END IF

ib_update_check = True
end event

type dw_master from w_abc_master_smpl`dw_master within w_ba100_articulos_basc
integer x = 37
integer y = 32
integer width = 2345
integer height = 1316
string dataobject = "d_abc_articulo_grupo"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2
	if dwo.name = 'cod_art' then
		ls_sql = "select cod_art as codigo, nom_articulo as descripcion from articulo" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.cod_art [row] = ls_return1
				this.object.articulo_nom_articulo[row] = ls_return2
				this.ii_update = 1
	end if
end if
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.grupo_art[al_row] = is_grupobasc
end event

event dw_master::itemchanged;call super::itemchanged;idw_1 = this
idw_1.GetText()
idw_1.AcceptText()
string ls_desc, ls_null
setnull(ls_null)
if dwo.name = 'cod_art' then
				
				select nom_articulo into :ls_desc
				  from articulo
				 where (trim(cod_art) = trim(:data));
				
				if sqlca.sqlcode = 100 then
					
					this.object.cod_art  [row] = ls_null
					this.object.nom_articulo [row] = ls_null
					Messagebox(this.title, 'Articulo Inexistente')
					Return 1
				else
					this.object.nom_articulo [row] = ls_desc
				end if
end if
end event

