$PBExportHeader$w_cam050_ley_fertilizacion.srw
forward
global type w_cam050_ley_fertilizacion from w_abc_master_smpl
end type
end forward

global type w_cam050_ley_fertilizacion from w_abc_master_smpl
integer height = 1064
string title = "[CAM050] Ley de Fertilización"
string menuname = "m_abc_master_smpl"
end type
global w_cam050_ley_fertilizacion w_cam050_ley_fertilizacion

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],is_colname_d[],is_coltype_d[]
n_cst_log_diario	in_log
end variables

on w_cam050_ley_fertilizacion.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam050_ley_fertilizacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update;call super::ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
	END IF
	DESTROY lds_log_m
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_cam050_ley_fertilizacion
string dataobject = "d_abc_ley_fertilizacion"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_id, li_item = 0, li_row

select max(nro_item)
	into :li_id
from sic_ley_fertilizacion;

if dw_master.RowCount( ) > 0 then
	for li_row = 1 to dw_master.RowCount( )
			if li_item < Int(dw_master.object.nro_item[li_row]) then
				li_item = Int(dw_master.object.nro_item[li_row])
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

this.object.nro_item	[al_row] = li_id
this.object.nitro			[al_row] = 0.00
this.object.fosfo		[al_row] = 0.00
this.object.pota			[al_row] = 0.00
this.object.calc			[al_row] = 0.00
this.object.magn		[al_row] = 0.00
this.object.azuf			[al_row] = 0.00
this.setcolumn('fertilizante')
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
	CASE 'und'
		
		// Verifica que codigo ingresado exista			
		Select und
	     into :ls_desc1
		  from unidad
		 Where und = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe La unidad Ingresada o Esta inactiva")
			this.object.und		[row] = ls_null
			return 1
			
		end if
		
		this.object.und	[row] = data

END CHOOSE
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "und"
		 ls_sql = "Select t.und as codigo_unidad, " &
		 		  + "t.desc_unidad as descripcion_unidad " &
		 		  + "from unidad t " &
				  + "Where flag_estado <> '0' "
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.und		[al_row] = ls_codigo
			THIS.ii_update = 1
		END IF
		
END CHOOSE
end event

