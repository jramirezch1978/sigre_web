$PBExportHeader$w_af012_registro_operaciones.srw
forward
global type w_af012_registro_operaciones from w_abc_master_smpl
end type
end forward

global type w_af012_registro_operaciones from w_abc_master_smpl
integer width = 2711
integer height = 940
string title = "(AF012) Operaciones de los Activos"
string menuname = "m_master_simple"
long backcolor = 67108864
end type
global w_af012_registro_operaciones w_af012_registro_operaciones

type variables

end variables

on w_af012_registro_operaciones.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af012_registro_operaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;string ls_protect

ls_protect=dw_master.Describe("calculo_tipo.protect")
if ls_protect='0' then
   dw_master.of_column_protect('calculo_tipo')
end if

end event

event ue_open_pre();call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250
This.move(ll_x,ll_y)

end event

event ue_update_pre;//string  ls_calculo_tipo, ls_descripcion
//integer li_row, li_nro_libro, li_verifica

// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE


end event

event open;call super::open;ib_log = TRUE
end event

event ue_update;// Ancester Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_af012_registro_operaciones
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 32
integer width = 2624
integer height = 684
string dataobject = "dw_operaciones_activo_tbl"
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			
sg_parametros sl_param

ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE "nro_libro"
		ls_sql = "SELECT NRO_LIBRO AS CODIGO, " &
				  +"DESC_LIBRO AS DESCRIPCION " &
				  +"FROM CNTBL_LIBRO " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_libro [al_row] = long(ls_codigo)
			This.object.desc_libro[al_row] = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;
// BloqUea los registros ya ingresados
dw_master.Modify("calculo_tipo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nro_libro.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_null, ls_expresion
Long	 ld_null, ll_found

SetNull(ls_null)
SetNull(ld_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'nro_libro'
		SELECT desc_libro	
		 INTO :ls_data
		FROM cntbl_libro	
		WHERE nro_libro = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL LIBRO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.nro_libro [row] = ld_null
			This.object.desc_libro[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_libro[row]	= ls_data
		
	CASE 'calculo_tipo'
		ls_expresion = "calculo_tipo = '"+ data +"'" 
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
						
	  	IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			This.object.calculo_tipo[row] = ls_null
   		RETURN 1
		END IF
		
END CHOOSE

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

