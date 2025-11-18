$PBExportHeader$w_ve021_ccosto_gasto_x_art.srw
forward
global type w_ve021_ccosto_gasto_x_art from w_abc
end type
type dw_master from u_dw_abc within w_ve021_ccosto_gasto_x_art
end type
end forward

global type w_ve021_ccosto_gasto_x_art from w_abc
integer width = 4064
integer height = 1624
string title = "Centos de Costo de Gasto por Articulo (VE021)"
string menuname = "m_mantenimiento"
dw_master dw_master
end type
global w_ve021_ccosto_gasto_x_art w_ve021_ccosto_gasto_x_art

on w_ve021_ccosto_gasto_x_art.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ve021_ccosto_gasto_x_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija


dw_master.Retrieve()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

type dw_master from u_dw_abc within w_ve021_ccosto_gasto_x_art
event ue_display ( string as_columna,  long al_row )
integer x = 32
integer y = 8
integer width = 3991
integer height = 1412
string dataobject = "d_abc_art_ccosto_gasto_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
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
	
	CASE "CENCOS"
		ls_sql = "SELECT CENCOS AS CODIGO, " &
			    + "DESC_CENCOS AS DESCRIPCION " 	&
				 + "FROM CENTROS_COSTO "				&
				 + "WHERE FLAG_ESTADO = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos	   [al_row] = ls_codigo
			This.object.desc_cencos	[al_row] = ls_data
			This.ii_update = 1
		END IF

 CASE "COD_ORIGEN"
		ls_sql = "SELECT COD_ORIGEN AS CODIGO, " &
			    + "NOMBRE AS DESCRIPCION " 	&
				 + "FROM ORIGEN "				&
				 + "WHERE FLAG_ESTADO = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_origen [al_row] = ls_codigo
			This.object.nombre     [al_row] = ls_data
			This.ii_update = 1
		END IF


END CHOOSE
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;String ls_nombre,ls_null

SetNull(ls_null)

Accepttext()

choose case dwo.name
	 	 case 'cod_origen'
				
				select nombre into :ls_nombre
				  from origen
				 where (cod_origen  = :data ) and
				 		 (flag_estado = '1'   ) ;
				  
 
						  
			  if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Origen No Existe o Esta Inactivo,Verifique!')	
				  this.object.cod_origen [row] = ls_null
				  This.object.nombre     [row] = ls_null
				  Return 1
			  else
			     This.object.nombre     [row] = ls_nombre
			  end if		
			  
		 case 'cod_art'
			   
				select a.nom_articulo into :ls_nombre
				  from articulo_venta av,articulo a 
				 where (av.cod_art    = a.cod_art) and
				 		 (av.cod_art	 = :data	 ) and
				 		 (a.flag_estado = '1'      );
				 
				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Codigo de Articulo No Existe o Esta Inactivo,Verifique!')	
				  this.object.cod_art      [row] = ls_null
				  This.object.nom_articulo [row] = ls_null
				  Return 1
			  else
			     This.object.nom_articulo [row] = ls_nombre
			  end if		 
			  
			  
		 case 'cencos'	
				select cencos,desc_cencos,flag_estado 
				  into :ls_nombre	
				  from centros_costo 
				 where (cencos      = :data ) and
				 		 (flag_estado = '1'   ) ;
						  
				if sqlca.sqlcode = 100 then
				  Messagebox('Aviso','Centro de Costo No Existe o Esta Inactivo,Verifique!')	
				  this.object.cencos      [row] = ls_null
				  This.object.desc_cencos [row] = ls_null
				  Return 1
			  else
			     This.object.desc_cencos [row] = ls_nombre
			  end if		 
						  
		
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

