$PBExportHeader$w_ve002_factor_embarque.srw
forward
global type w_ve002_factor_embarque from w_abc_master
end type
end forward

global type w_ve002_factor_embarque from w_abc_master
integer width = 2167
integer height = 1112
string title = "[VE002] Factor de Embarque"
string menuname = "m_mantenimiento_lista"
boolean maxbox = false
boolean resizable = false
end type
global w_ve002_factor_embarque w_ve002_factor_embarque

forward prototypes
public subroutine of_retrieve (string as_cod_art, string as_forma_empaque, string as_incoterm, string as_puerto)
end prototypes

public subroutine of_retrieve (string as_cod_art, string as_forma_empaque, string as_incoterm, string as_puerto);Long ll_row

messagebox('', as_cod_art+'**' + as_forma_empaque + '**' + as_incoterm + '**' + as_puerto+'**')
ll_row = dw_master.retrieve(as_cod_art, as_forma_empaque, as_incoterm, as_puerto)
	
dw_master.ii_protect = 0
dw_master.of_protect()
	
Return 
end subroutine

on w_ve002_factor_embarque.create
call super::create
if this.MenuName = "m_mantenimiento_lista" then this.MenuID = create m_mantenimiento_lista
end on

on w_ve002_factor_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;
//idw_1.retrieve( )

this.MenuId.item[1].item[1].item[1].enabled = True
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = True

of_position_window(50,50)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'form') = false then
	ib_update_check = false
	return
end if
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop

integer li_i, li_array

str_parametros sl_param

sl_param.dw1    = 'd_ve_lista_embarque_factor_tbl'
sl_param.titulo = 'Factor de Embarque'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 3
sl_param.field_ret_i[3] = 5
sl_param.field_ret_i[4] = 7

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2], &
					sl_param.field_ret[3], sl_param.field_ret[4])
END IF

end event

event resize;//Override
end event

type dw_master from w_abc_master`dw_master within w_ve002_factor_embarque
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 32
integer width = 2053
integer height = 836
string dataobject = "d_ve_embarque_factor_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "COD_ART"
		ls_sql = "SELECT DISTINCT A.COD_ART AS CODIGO, " &
			    + "A.NOM_ARTICULO AS DESCRIPCION " 		 &
				 + "FROM ARTICULO A, " 							 &
				 + "ARTICULO_VENTA AV " 						 &
				 + "WHERE A.COD_ART = AV.COD_ART " 			 &
				 + "AND A.FLAG_ESTADO = '1' " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_art		[al_row] = ls_codigo
			This.object.nom_articulo[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE "FORMA_EMPAQUE"
		ls_sql = "SELECT FORMA_EMPAQUE AS CODIGO, " 	&
			    + "DESCRIPCION AS DESCRIPCION " 		&
				 + "FROM FORMA_EMPAQUE " 					&
				 + "WHERE FLAG_ESTADO = '1' " 		

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.forma_empaque				 [al_row] = ls_codigo
			This.object.forma_empaque_descripcion[al_row] = ls_data
			This.ii_update = 1
		END IF
		
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
		
	CASE "PUERTO"
		ls_sql = "SELECT PUERTO AS CODIGO, " 		&
			    + "DESCR_PUERTO AS DESCRIPCION " 	&
				 + "FROM FL_PUERTOS " 					&
				 + "WHERE FLAG_ESTADO = '1' " 			

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.puerto		[al_row] = ls_codigo
			This.object.descr_puerto[al_row] = ls_data
			This.ii_update = 1
		END IF
		
		
	CASE "COD_PLANTILLA"

		ls_sql = "SELECT COD_PLANTILLA AS CODIGO, " 	&
			    + "DESC_PLANTILLA AS DESCRIPCION " 	&
				 + "FROM vw_plant_ot_adm " 				&
				 + "WHERE FLAG_ESTADO = '1' " 			&
				 + "AND cod_usr = '" + gs_user + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_plantilla	[al_row] = ls_codigo
			This.object.desc_plantilla	[al_row] = ls_data
			This.ii_update = 1
		END IF
		
		
	CASE "UND_EMBARQUE"
		ls_sql = "SELECT UND AS CODIGO, " 		&
			    + "DESC_UNIDAD AS DESCRIPCION " &
				 + "FROM UNIDAD " 					
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.und_embarque[al_row] = ls_codigo
			This.object.desc_unidad	[al_row] = ls_data
			This.ii_update = 1
		END IF


END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemerror;call super::itemerror;return 1
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
	
	CASE "COD_ART"
		SELECT a.nom_articulo
			INTO :ls_data
		FROM articulo 			a,
		     articulo_venta  av
		WHERE a.cod_art = :data
		  AND a.cod_art = av.cod_art
		  AND  flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Articulo no existe", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_articulo[row] = ls_data
	
	CASE "FORMA_EMPAQUE"
		SELECT descripcion
			INTO :ls_data
		FROM forma_empaque
		WHERE forma_empaque = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Forma de Empaque no existe", StopSign!)
			this.object.forma_empaque					[row] = ls_Null
			this.object.forma_empaque_descripcion	[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.forma_empaque_descripcion[row] = ls_data
				
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
		
	CASE "PUERTO"
		SELECT descr_puerto
			INTO :ls_data
		FROM fl_puertos
		WHERE puerto = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Puerto no existe", StopSign!)
			this.object.puerto		[row] = ls_Null
			this.object.descr_puerto[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.descr_puerto[row] = ls_data

	CASE "COD_PLANTILLA"
		SELECT DESC_PLANTILLA
			INTO :ls_data
		FROM vw_plant_ot_adm
	  	WHERE FLAG_ESTADO = '1'
		  and cod_plantilla = :data;

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Plantilla no existe", StopSign!)
			this.object.cod_plantilla	[row] = ls_Null
			this.object.desc_plantilla	[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.desc_plantilla[row] = ls_data

	CASE "UND_EMBARQUE"
		SELECT desc_unidad
			INTO :ls_data
		FROM unidad
		WHERE und = :data
		  AND flag_estado = '1';

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Unidad no existe", StopSign!)
			this.object.und_embarque[row] = ls_Null
			this.object.desc_unidad	[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.desc_unidad[row] = ls_data
	
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

