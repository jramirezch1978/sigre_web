$PBExportHeader$w_ve004_articulo_caract_embarque.srw
forward
global type w_ve004_articulo_caract_embarque from w_abc_master
end type
end forward

global type w_ve004_articulo_caract_embarque from w_abc_master
integer width = 3557
integer height = 1304
string title = "[VE004] Articulo - Caracteristicas de Embarque"
string menuname = "m_mantenimiento"
boolean maxbox = false
boolean resizable = false
end type
global w_ve004_articulo_caract_embarque w_ve004_articulo_caract_embarque

on w_ve004_articulo_caract_embarque.create
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
end on

on w_ve004_articulo_caract_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve( )

of_position_window(50,50)

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event resize;//Override

end event

type dw_master from w_abc_master`dw_master within w_ve004_articulo_caract_embarque
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 32
integer width = 3451
integer height = 1028
string dataobject = "d_ve_articulo_caract_embarque_tbl"
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "COD_ART"
		ls_sql = "SELECT DISTINCT A.COD_ART AS CODIGO, " 	&
			    + "A.NOM_ARTICULO AS DESCRIPCION " 			&
				 + "FROM ARTICULO 	A, " 							&
				 + "ARTICULO_VENTA 	AV "							&
				 + "WHERE A.COD_ART = AV.COD_ART "				&
				 + "AND FLAG_ESTADO = '1' " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_art		[al_row] = ls_codigo
			This.object.nom_articulo[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE "CARACTERISTICA"
		ls_sql = "SELECT CARACTERISTICA AS CODIGO, " &
			    + "DESCRIPCION AS DESCRIPCION " 	&
				 + "FROM CARACT_EMBARQUE "				&
				 + "WHERE FLAG_ESTADO = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.caracteristica	[al_row] = ls_codigo
			This.object.descripcion		[al_row] = ls_data
			This.ii_update = 1
		END IF


END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

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

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "COD_ART"
		SELECT a.nom_articulo
			INTO :ls_data
		FROM articulo   		a,
		     articulo_venta 	av
		WHERE a.cod_art = :data
		  AND a.cod_art = av.cod_art
		  AND flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Articulo no existe", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_articulo[row] = ls_data
	
	CASE "CARACTERISTICA"
		SELECT descripcion
			INTO :ls_data
		FROM Caract_embarque
		WHERE caracteristica = :data
		  AND flag_estado 	= '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Caracteristica de Embarque no existe", StopSign!)
			this.object.caracteristica	[row] = ls_Null
			this.object.descripcion		[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.descripcion[row] = ls_data
				
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

