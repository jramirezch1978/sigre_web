$PBExportHeader$w_ap015_factores_conversion.srw
forward
global type w_ap015_factores_conversion from w_abc_master
end type
end forward

global type w_ap015_factores_conversion from w_abc_master
integer width = 2309
integer height = 1220
string title = "Factores de Conversion (AP015) "
string menuname = "m_mantto_smpl"
end type
global w_ap015_factores_conversion w_ap015_factores_conversion

on w_ap015_factores_conversion.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap015_factores_conversion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()
//idw_query = dw_master

//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

type dw_master from w_abc_master`dw_master within w_ap015_factores_conversion
event ue_display ( string as_columna,  long al_row )
integer width = 2245
integer height = 988
string dataobject = "d_ap_factores_conversion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE upper(as_columna)
	
	CASE 'UND_INGR'
		ls_sql = "SELECT und as Codigo_unidad, " &
				 + "desc_unidad as descripcion " 	  &
				 + "FROM unidad "			
					
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.und_ingr		[al_row] = ls_codigo
			THIS.object.desc_unidad [al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
	CASE "UND_CONV"
		ls_sql = "SELECT und as Codigo_unidad, " &
				 + "desc_unidad as descripcion " 	  &
				 + "FROM unidad "			
					
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.und_conv			[al_row] = ls_codigo
			THIS.object.desc_unidad_1  [al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                      //  'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = 	dw_master
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

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null

SetNull(ls_null)
this.accepttext( )

CHOOSE CASE upper(dwo.name)

	CASE 'UND_INGR' 
		SELECT desc_unidad
			INTO :ls_desc
		FROM Unidad
		WHERE und =:data;
		
		IF sqlca.sqlcode = 100 THEN
			messagebox(parent.title, 'Codigo de unidad no existe')
			THIS.object.und_ingr 	[row] = ls_null
			THIS.object.desc_unidad	[row] = ls_null
			return 1
		END IF
	
		THIS.object.desc_unidad [row] = ls_desc
	
	CASE 'UND_CONV'
		SELECT desc_unidad
			INTO :ls_desc
		FROM Unidad
		WHERE und =:data;
		
		IF sqlca.sqlcode = 100 THEN
			messagebox(parent.title, 'Codigo de unidad no existe')
			THIS.object.und_conv 		[row] = ls_null
			THIS.object.desc_unidad_1	[row] = ls_null
			return 1
		END IF
	
		THIS.object.desc_unidad_1 [row] = ls_desc
		
END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

