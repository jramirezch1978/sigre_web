$PBExportHeader$w_rh024_confin_trabajador.srw
forward
global type w_rh024_confin_trabajador from w_abc_master_smpl
end type
end forward

global type w_rh024_confin_trabajador from w_abc_master_smpl
integer width = 3397
integer height = 1712
string title = "[RH024] Concepto Financiero - Tipo Trabajador"
string menuname = "m_master_simple"
end type
global w_rh024_confin_trabajador w_rh024_confin_trabajador

on w_rh024_confin_trabajador.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh024_confin_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_rh024_confin_trabajador
event ue_display ( string as_columna,  long al_row )
integer width = 3218
integer height = 1324
string dataobject = "d_abc_confin_tipo_trabaj_tbl"
end type

event dw_master::ue_display;boolean 			lb_ret
string 			ls_data, ls_sql, ls_codigo
str_parametros	lstr_param

this.AcceptText()

choose case lower(as_columna)
		
	case "tipo_trabajador"
		ls_sql = "SELECT tipo_trabajador AS tipo_trabajador, " &
				  + "desc_tipo_tra AS descripcion_tipo_trabajador " &
				  + "FROM tipo_trabajador " &
				  + "where flag_estado = '1' " &
  				  + "order by desc_tipo_tra " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_trabajador		[al_row] = ls_codigo
			this.object.desc_tipo_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	case "confin"
		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 1
		lstr_param.str_array[1] = '6'
		lstr_param.str_array[2] = '4'
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
		END IF
		
		return
	
end choose

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

event dw_master::itemchanged;call super::itemchanged;string 	ls_null, ls_mensaje, ls_desc

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
	
	CASE 'tipo_trabajador'

		SELECT desc_tipo_tra
			INTO :ls_desc
		FROM tipo_trabajador
   	WHERE  tipo_trabajador = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Tipo de Trabajador no existe, ' &
					+ 'no esta activo, por favor verifique')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.tipo_trabajador		[row] = ls_null
			this.object.desc_tipo_trabajador [row] = ls_null
			this.setcolumn( "tipo_trabajador" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_tipo_trabajador [row] = ls_desc
		
	CASE 'cod_usr'

		SELECT nombre
			INTO :ls_desc
		FROM usuario
   	WHERE  cod_usr = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Código de usuario no existe, ' &
					+ 'no esta activo, por favor verifique')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.cod_usr		[row] = ls_null
			this.object.nom_usuario [row] = ls_null
			this.setcolumn( "cod_usr" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.nom_usuario [row] = ls_desc

END CHOOSE

end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

