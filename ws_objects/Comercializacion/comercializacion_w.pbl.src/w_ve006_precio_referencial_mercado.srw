$PBExportHeader$w_ve006_precio_referencial_mercado.srw
forward
global type w_ve006_precio_referencial_mercado from w_abc_master
end type
end forward

global type w_ve006_precio_referencial_mercado from w_abc_master
integer width = 4325
integer height = 1744
string title = "[VE006] Precio Referencia de Mercado"
string menuname = "m_mantenimiento_sl"
end type
global w_ve006_precio_referencial_mercado w_ve006_precio_referencial_mercado

on w_ve006_precio_referencial_mercado.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve006_precio_referencial_mercado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()

of_position_window(50,50)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 30
dw_master.height = newheight - dw_master.y - 30
end event

type dw_master from w_abc_master`dw_master within w_ve006_precio_referencial_mercado
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 32
integer width = 4192
integer height = 1444
string dataobject = "d_ve_precio_referencial_mercado_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "INCOTERM"
		ls_sql = "SELECT INCOTERM AS CODIGO, " &
			    + "DESCRIPCION AS DESCRIPCION " &
				 + "FROM INCOTERM " 					&
				 + "WHERE FLAG_ESTADO = '1' " 	

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.incoterm					[al_row] = ls_codigo
			This.object.incoterm_descripcion	[al_row] = ls_data
			This.ii_update = 1
		END IF	
	
	CASE "COD_ART"
		ls_sql = "SELECT COD_ART AS CODIGO, " 		&
			    + "NOM_ARTICULO AS DESCRIPCION " 	&
				 + "FROM ARTICULO " 						&
				 + "WHERE FLAG_ESTADO = '1' " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_art		[al_row] = ls_codigo
			This.object.nom_articulo[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	
	CASE "MON"
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " 	&
			    + "DESCRIPCION AS DESCRIPCION " 	&
				 + "FROM MONEDA " 						&
				 + "WHERE FLAG_ESTADO = '1' " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.mon					[al_row] = ls_codigo
			This.object.moneda_descripcion[al_row] = ls_data
			This.ii_update = 1
		END IF

	
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "INCOTERM"
		SELECT descripcion
			INTO :ls_data
		FROM Incoterm
		WHERE incoterm = :data
		  AND flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de INCOTERM no existe", StopSign!)
			this.object.incoterm					[row] = ls_Null
			this.object.incoterm_descripcion	[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.incoterm_descripcion[row] = ls_data
	
	
	CASE "COD_ART"
		SELECT nom_articulo
			INTO :ls_data
		FROM articulo
		WHERE cod_art = :data
		  AND flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Articulo no existe", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_articulo[row] = ls_data
		
	CASE "MON"
		SELECT descripcion
			INTO :ls_data
		FROM moneda
		WHERE cod_moneda = :data
		  AND flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Moneda no existe", StopSign!)
			this.object.mon		 			[row] = ls_Null
			this.object.moneda_descripcion[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.moneda_descripcion[row] = ls_data
	
END CHOOSE
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

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

event dw_master::ue_insert_pre;call super::ue_insert_pre;This.object.usr_registro	[al_row] = gs_user
This.object.fecha_registro	[al_row] = f_fecha_actual()
end event

