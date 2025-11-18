$PBExportHeader$w_cam034_preguntas_gg.srw
forward
global type w_cam034_preguntas_gg from w_abc_master_smpl
end type
end forward

global type w_cam034_preguntas_gg from w_abc_master_smpl
integer height = 1064
string title = "[CAM034] Preguntas Global GAP"
string menuname = "m_abc_master_smpl"
end type
global w_cam034_preguntas_gg w_cam034_preguntas_gg

type variables

end variables

on w_cam034_preguntas_gg.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam034_preguntas_gg.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_cam034_preguntas_gg
string dataobject = "d_abc_sic_preguntas_gg"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_id, li_item = 0, li_row

select max(id_req)
	into :li_id
from sic_global_gap_preg;

if dw_master.RowCount( ) > 0 then
	for li_row = 1 to dw_master.RowCount( )
			if li_item < Int(dw_master.object.id_req[li_row]) then
				li_item = Int(dw_master.object.id_req[li_row])
			end if
	next
end if

if isNull(li_id) then
	li_id = 0
end if

if li_item > li_id then
	li_id = li_item
end if
li_id = li_id +1

this.object.id_req[al_row] = li_id
this.object.flag_estado[al_row] = '1'
this.object.flag_pregunta[al_row] = '1'
this.setcolumn('cod_req')



end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_modulo'
		
		// Verifica que codigo ingresado exista			
		Select desc_modulo
	     into :ls_desc1
		  from sic_global_gap_mod
		 Where cod_modulo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de Base o No se encuentra activo, por favor verifique")
			this.object.cod_modulo		[row] = ls_null
			return 1
			
		end if

END CHOOSE
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_modulo"
		 ls_sql = "Select t.cod_modulo as codigo_modulo, " &
		 		  + "t.desc_modulo as descripcion_modulo " &
		 		  + "from Sic_global_gap_mod t " &
				  + "Where flag_estado <> '0' "
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_modulo		[al_row] = ls_codigo
			THIS.ii_update = 1
		END IF
		
END CHOOSE
end event

