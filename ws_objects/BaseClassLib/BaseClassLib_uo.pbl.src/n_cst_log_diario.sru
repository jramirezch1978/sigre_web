$PBExportHeader$n_cst_log_diario.sru
$PBExportComments$funciones para encriptar y desencriptar datos
forward
global type n_cst_log_diario from nonvisualobject
end type
end forward

global type n_cst_log_diario from nonvisualobject
end type
global n_cst_log_diario n_cst_log_diario

forward prototypes
public function string of_get_key_log (datastore ads_master, long al_row, string as_colname[], string as_coltype[], integer ai_ck[])
public function string of_get_key_log (datawindow adw_master, long al_row, string as_colname[], string as_coltype[], integer ai_ck[])
public function integer of_put_log (string as_tabla, string as_operacion, string as_llave, string as_campo, string as_val_anterior, string as_val_nuevo, string as_cod_usr)
public function integer of_create_log (u_dw_abc adw_master, ref datastore ads_log, string as_colname[], string as_coltype[], string as_user, string as_table, string as_empresa)
public subroutine of_dw_map (u_dw_abc adw_1, ref string as_colname[], ref string as_coltype[])
end prototypes

public function string of_get_key_log (datastore ads_master, long al_row, string as_colname[], string as_coltype[], integer ai_ck[]);Integer			li_x, li_totcol, li_y, li_key
Long				ll_row
String			ls_temp, ls_campo, ls_type, ls_key


li_totcol = UpperBound(ai_ck)

FOR li_x = 1 TO li_totcol
	ls_campo  = as_colname[ai_ck[li_x]]
	ls_type = as_coltype[ai_ck[li_x]]
	CHOOSE CASE ls_type
		CASE 'date'
				ls_temp = String(ads_master.GetItemDate(al_row,ls_campo), 'dd/mm/yyyy')
		CASE 'datetime'
				ls_temp = String(ads_master.GetItemDateTime(al_row,ls_campo), 'dd/mm/yyyy hh:mm:ss')
		CASE 'char'
				ls_temp = ads_master.GetItemString(al_row,ls_campo)
		CASE 'decimal'
				ls_temp = String(ads_master.GetItemDecimal(al_row,ls_campo))			
		CASE Else
				ls_temp = String(ads_master.GetItemNumber(al_row,ls_campo))
	END CHOOSE
	ls_key = ls_key + ',' + ls_temp
NEXT

ls_key = Mid(ls_key, 2)

RETURN ls_key


end function

public function string of_get_key_log (datawindow adw_master, long al_row, string as_colname[], string as_coltype[], integer ai_ck[]);Integer			li_x, li_totcol, li_y, li_key
Long				ll_row
String			ls_temp, ls_campo, ls_type, ls_key


li_totcol = UpperBound(ai_ck)

FOR li_x = 1 TO li_totcol
	ls_campo  = as_colname[ai_ck[li_x]]
	ls_type = as_coltype[ai_ck[li_x]]
	CHOOSE CASE ls_type
		CASE 'date'
				ls_temp = String(adw_master.GetItemDate(al_row,ls_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				ls_temp = String(adw_master.GetItemDateTime(al_row,ls_campo), 'dd/mm/yyyy hh:mm:ss')
		CASE 'char'
				ls_temp = adw_master.GetItemString(al_row,ls_campo)
		CASE 'decimal'
				ls_temp = String(adw_master.GetItemDecimal(al_row,ls_campo))			
		CASE Else
				ls_temp = String(adw_master.GetItemNumber(al_row,ls_campo))
	END CHOOSE
	ls_key = ls_key + ',' + ls_temp
NEXT

ls_key = Mid(ls_key, 2)

RETURN ls_key


end function

public function integer of_put_log (string as_tabla, string as_operacion, string as_llave, string as_campo, string as_val_anterior, string as_val_nuevo, string as_cod_usr);DateTime	ldt_now

ldt_now = Datetime(Today(), Now())

INSERT INTO "log_diario"  
          ( "fecha", "tabla", "operacion", "llave", "campo",
			   "val_anterior", "val_nuevo", "cod_usr")  
  VALUES ( :ldt_now, :as_tabla, :as_operacion, :as_llave, :as_campo,   
             :as_val_anterior, :as_val_nuevo, :as_cod_usr)  ;

//IF sqlca.sqlcode = 0 THEN
//   COMMIT ;
//ELSE
//	MessageBox ("Error", 'No se pudo grabar el Log')
//	Rollback ;
//END IF

RETURN SQLCA.SQLCode
end function

public function integer of_create_log (u_dw_abc adw_master, ref datastore ads_log, string as_colname[], string as_coltype[], string as_user, string as_table, string as_empresa);Integer			li_totcol, li_y, li_key, li_rc
dwItemStatus	ldis_status
Datastore		lds_del
Long				ll_row, ll_x, ll_totdel
String			ls_actual, ls_nuevo, ls_campo, ls_type, ls_key

lds_del = Create DataStore
ads_log.Reset()
lds_del.DataObject = adw_master.DataObject

adw_master.RowsCopy(1, adw_master.il_totdel, Delete!, lds_del, 1, Primary!)
//adw_master.SetFilter('#1 = #1')
//adw_master.Filter()
li_totcol = Integer(adw_master.Object.DataWindow.Column.Count)
ll_totdel = lds_del.RowCount()

//Registros Eliminados
FOR ll_x = 1 TO lds_del.RowCount()              // deletes
	ll_row = ads_log.InsertRow(0)
	ads_log.SetItem(ll_row,'operacion','Elimin')
	ls_key = of_get_key_log(lds_del, ll_x, as_colname, as_coltype, adw_master.ii_ck)
	ads_log.SetItem(ll_row,'llave', ls_key)
	ads_log.SetItem(ll_row,'fecha',f_fecha_actual(0))
	ads_log.SetItem(ll_row,'cod_usr', as_user)
	ads_log.SetItem(ll_row,'tabla', as_table)
	ads_log.SetItem(ll_row,'empresa', as_empresa)
Next

//Registros Modificados e Insertados
FOR ll_x = 1 TO adw_master.RowCount()
	ldis_status = adw_master.GetItemStatus(ll_x,0,Primary!)
	IF ldis_status = NewMOdified! THEN           // inserts 
		ll_row = ads_log.InsertRow(0)
		ads_log.SetItem(ll_row,'operacion','Insert')
		ls_key = of_get_key_log(adw_master, ll_x, as_colname, as_coltype, adw_master.ii_ck)
		ads_log.SetItem(ll_row,'llave',ls_key)
		ads_log.SetItem(ll_row,'fecha',Datetime(Today(),Now()))
		ads_log.SetItem(ll_row,'cod_usr', as_user)
		ads_log.SetItem(ll_row,'tabla', as_table)
		ads_log.SetItem(ll_row,'empresa', as_empresa)
	ELSE
		IF ldis_status = DataModified! THEN       // modified
			ls_key = of_get_key_log(adw_master, ll_x, as_colname, as_coltype, adw_master.ii_ck)
			FOR li_y = 1 TO li_totcol
				ldis_status = adw_master.GetItemStatus(ll_x,li_y,Primary!) //recoger status de la columna
				IF ldis_status = DataModified! THEN // solo debe proceder si la columna ha sido modificada
					ls_campo = as_colname[li_y] // nombre del campo
					ls_type  = as_coltype[li_y] // tipo del campo
					IF ls_campo = 'flag_replicacion' THEN CONTINUE //si el campo es de replicacion no grabar

					CHOOSE CASE ls_type
						CASE 'date'
							ls_actual = String(adw_master.GetItemDate(ll_x,ls_campo,Primary!,TRUE), 'dd/mm/yyyy')
							ls_nuevo  = String(adw_master.GetItemDate(ll_x,ls_campo,Primary!,FALSE), 'dd/mm/yyyy')
						CASE 'datetime'
							ls_actual = String(adw_master.GetItemDateTime(ll_x,ls_campo,Primary!,TRUE), 'dd/mm/yyyy hh:mm:ss')
							ls_nuevo  = String(adw_master.GetItemDateTime(ll_x,ls_campo,Primary!,FALSE), 'dd/mm/yyyy hh:mm:ss')
						CASE 'decimal'
							ls_actual = String(adw_master.GetItemDecimal(ll_x,ls_campo,Primary!,TRUE))
							ls_nuevo  = String(adw_master.GetItemDecimal(ll_x,ls_campo,Primary!,FALSE))
						CASE 'char'
							ls_actual = adw_master.GetItemString(ll_x,ls_campo,Primary!,TRUE)
							ls_nuevo  = adw_master.GetItemString(ll_x,ls_campo,Primary!,FALSE)
						CASE Else
							ls_actual = String(adw_master.GetItemNumber(ll_x,ls_campo,Primary!,TRUE))
							ls_nuevo  = String(adw_master.GetItemNumber(ll_x,ls_campo,Primary!,FALSE))
					END CHOOSE
					IF ls_actual <> ls_nuevo THEN
						ll_row = ads_log.InsertRow(0) // agregar fila al dw log
						ads_log.SetItem(ll_row,'operacion','Modifi')
						ads_log.SetItem(ll_row,'llave',ls_key)
						ads_log.SetItem(ll_row,'val_anterior',ls_actual)
						ads_log.SetItem(ll_row,'val_nuevo',ls_nuevo)
						ads_log.SetItem(ll_row,'campo',ls_campo)
						ads_log.SetItem(ll_row,'fecha',Datetime(Today(),Now()))
						ads_log.SetItem(ll_row,'cod_usr', as_user)
						ads_log.SetItem(ll_row,'tabla', as_table)
						ads_log.SetItem(ll_row,'empresa', as_empresa)
					END IF
				END IF
			NEXT
		END IF
	END IF	
Next

Destroy lds_del

Return li_rc   // 0 =ok, 1 = error

end function

public subroutine of_dw_map (u_dw_abc adw_1, ref string as_colname[], ref string as_coltype[]);Integer			li_x, li_totcol
Long				ll_row

if not adw_1.isValidDataObject() then return

li_totcol = Integer(adw_1.Object.DataWindow.Column.Count)

FOR li_x = 1 to li_totcol
	as_colname[li_x] = adw_1.Describe('#' + String(li_x) + '.name')
	as_coltype[li_x] = adw_1.Describe(as_colname[li_x] + ".ColType")
	CHOOSE CASE as_coltype[li_x]
		CASE 'date'
		CASE 'datetime'
		CASE Else
				IF Left(as_coltype[li_x], 4) = 'char' THEN
					as_coltype[li_x] = 'char'
				ELSE
					IF Left(as_coltype[li_x], 7) = 'decimal' THEN
						as_coltype[li_x] = 'decimal'
					ELSE
						as_coltype[li_x] = 'numeric'
					END IF
				END IF
	END CHOOSE
Next



end subroutine

on n_cst_log_diario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_log_diario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

