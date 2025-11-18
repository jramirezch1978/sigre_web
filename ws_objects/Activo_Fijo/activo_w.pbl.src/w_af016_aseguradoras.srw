$PBExportHeader$w_af016_aseguradoras.srw
forward
global type w_af016_aseguradoras from w_abc_master_smpl
end type
end forward

global type w_af016_aseguradoras from w_abc_master_smpl
integer width = 2162
integer height = 1152
string title = "(AF016) Aseguradoras"
string menuname = "m_master_mant"
long backcolor = 67108864
end type
global w_af016_aseguradoras w_af016_aseguradoras

type variables

end variables

on w_af016_aseguradoras.create
call super::create
if this.MenuName = "m_master_mant" then this.MenuID = create m_master_mant
end on

on w_af016_aseguradoras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250
This.move(ll_x,ll_y)

end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
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

type dw_master from w_abc_master_smpl`dw_master within w_af016_aseguradoras
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 44
integer width = 2089
integer height = 908
string dataobject = "dw_aseguradora_tbl"
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
		   ls_expresion
Long	 	ll_found
			
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
	CASE "aseguradora"
		ls_sql = "select proveedor as codigo, " &
				  +"nom_proveedor as descripcion " &
				  +"from proveedor " &
				  +"where flag_estado  = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		ls_expresion = "aseguradora = '" + ls_codigo + "'"
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			RETURN 
		END IF
		
		IF ls_codigo <> '' THEN
			This.object.aseguradora[al_row] = ls_codigo
			This.object.descripcion[al_row] = ls_data
			This.ii_update = 1
		END IF
		
		
END CHOOSE


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_null, ls_expresion
Long	 ll_found

SetNull(ls_null)

This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		
	CASE 'aseguradora'
		
		ls_expresion = "aseguradora = '" + data + "'"
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			This.object.aseguradora[row] = ls_null
   		This.object.descripcion[row] = ls_null
			RETURN 1
			
		ELSE
		
			SELECT nom_proveedor
			 INTO :ls_data
			FROM proveedor
			WHERE proveedor = :data ;
		
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'EL PROVEEDOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.aseguradora[row] = ls_null
				This.object.descripcion[row] = ls_null
				RETURN 1
			END IF
		
			This.object.descripcion[row]	= ls_data
		END IF
		

END CHOOSE


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("aseguradora.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
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

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

