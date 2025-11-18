$PBExportHeader$w_rh225_establecimientos_rtps.srw
forward
global type w_rh225_establecimientos_rtps from w_abc
end type
type dw_master from u_dw_abc within w_rh225_establecimientos_rtps
end type
end forward

global type w_rh225_establecimientos_rtps from w_abc
integer width = 3762
integer height = 1208
string title = "Establecimientos(RH225)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh225_establecimientos_rtps w_rh225_establecimientos_rtps

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente

end event

on w_rh225_establecimientos_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh225_establecimientos_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

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

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_insert;call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type dw_master from u_dw_abc within w_rh225_establecimientos_rtps
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 36
integer width = 3675
integer height = 964
string dataobject = "d_abc_estableciminientos_rtps_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, ls_null, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r, &
			ls_pais, ls_dpto, ls_prov
Long		ll_row_find

str_parametros sl_param

Setnull(ls_null)

choose case upper(as_columna)
		
	case "COD_ORIGEN"

		ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM ORIGEN " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.object.origen_nombre  [al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "TIPO_ESTABLECIMIENTO"

		ls_sql = "SELECT TIPO_ESTABLECIMIENTO AS CODIGO, " &
				  + "DESCRIPCION AS DESC_tipo " &
				  + "FROM RRHH_TIPO_ESTABLECIMIENTO_RTPS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.TIPO_ESTABLECIMIENTO	[al_row] = ls_codigo
			this.object.DESCRIPCION          [al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "TIPO_VIA"

		ls_sql = "SELECT COD_VIA AS CODIGO, " &
				  + "DESCRIPCION AS DESC_VIA " &
				  + "FROM RRHH_VIAS_RTPS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_via	[al_row] = ls_codigo
			this.object.descripcion_via          [al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "COD_EMPRESA"

		ls_sql = "SELECT COD_EMPRESA AS CODIGO, " &
				  + "nombre AS DESC_tipo " &
				  + "FROM EMPRESA "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_empresa	[al_row] = ls_codigo
			this.object.nombre      [al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "TIPO_ZONA"

		ls_sql = "SELECT COD_ZONA AS CODIGO, " &
				  + "DESCRIPCION AS DESC_ZONA " &
				  + "FROM RRHH_ZONAS_RTPS " &
				  + "WHERE FLAG_ESTADO = '1'"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_zona	[al_row] = ls_codigo
			this.object.descripcion_zona      [al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "COD_CONDI"

		ls_sql = "SELECT COD_CONDICION_RPTS AS CODIGO, " &
				  + "DESCRIPCION AS DESC_CONDI " &
				  + "FROM RRHH_CONDICION_ESTABLE_RTPS " &
				  + "WHERE FLAG_ESTADO = '1'"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.COD_CONDI         [al_row] = ls_codigo
			this.object.DESCRIPCION_CONDI [al_row] = ls_data
			this.ii_update = 1
		end if
		///
		
		case 'COD_PAIS'

				ls_sql = "select cod_pais as codigo, nom_pais as desc_pais from pais"
				  
				lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
			if ls_codigo <> '' then
				this.object.COD_PAIS	[al_row] = ls_codigo
				this.object.desc_pais_n [al_row] = ls_data
			end if
		
				//limpiar departamento provincia distrito
				this.object.cod_dpto   [al_row] = ls_null		
				this.object.cod_prov   [al_row] = ls_null		
				this.object.cod_distr  [al_row] = ls_null
				
				this.object.desc_depto_n    [al_row] = ls_null		
				this.object.desc_prov_n     [al_row] = ls_null		
				this.object.desc_distrito_n [al_row] = ls_null		
	
		 case 'COD_DPTO'
			
			ls_pais = this.object.COD_PAIS  [al_row]	
			
			ls_sql = "select cod_dpto as codigo, desc_dpto as descripcion from departamento_estado " &
						  +" where cod_pais = "+"'"+ls_pais+"'"
				  
				lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
			if ls_codigo <> '' then
				this.object.cod_dpto	[al_row] = ls_codigo
				this.object.desc_depto_n [al_row] = ls_data
			end if

				//limpiar departamento provincia 
				this.object.cod_prov   [al_row] = ls_null		
				this.object.cod_distr  [al_row] = ls_null
				
				this.object.desc_prov_n     [al_row] = ls_null		
				this.object.desc_distrito_n [al_row] = ls_null		
				
		 case 'COD_PROV'
			
				ls_pais = this.object.COD_PAIS [al_row]
				ls_dpto = this.object.cod_dpto [al_row]
		
				ls_sql = "select cod_prov as codigo, desc_prov as descripcion from provincia_condado "&
						  +"where cod_pais = "+"'"+ls_pais+"' and " &
						  +"      cod_dpto = "+"'"+ls_dpto+"'"
                                                  
				lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
			if ls_codigo <> '' then
				this.object.cod_prov	[al_row] = ls_codigo
				this.object.desc_prov_n [al_row] = ls_data
			end if
		
				//limpiar departamento provincia 
				this.object.cod_distr  [al_row] = ls_null
				this.object.desc_distrito_n [al_row] = ls_null	
				
		 case 'COD_DISTR'
			
				ls_pais = this.object.COD_PAIS [al_row]
				ls_dpto = this.object.cod_dpto [al_row]
				ls_prov = this.object.cod_prov [al_row]
		
				ls_sql = "select cod_distr as codigo ,desc_distrito as descripcion from distrito "&
						  +" where cod_pais  = "+"'"+ls_pais+"' and "&
						  +"       cod_dpto	= "+"'"+ls_dpto+"' and "&
						  +"		  cod_prov	= "+"'"+ls_prov+"'"
						  
				lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
				if ls_codigo <> '' then
					this.object.cod_distr	[al_row] = ls_codigo
					this.object.desc_distrito_n [al_row] = ls_data
				end if
		
		///
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw

idw_mst = dw_master

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_cod_origen, ls_empresa, ls_dir_empresa

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	
  case "COD_ORIGEN"
		
		ls_codigo = this.object.cod_origen[row]

		SetNull(ls_data)
		select nombre
		  into :ls_data
		  from origen
		 where cod_origen  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_origen			[row] = ls_data
			this.object.origen_nombre	   [row] = ls_data
			return 1
		end if

		this.object.origen_nombre[row] = ls_data
		
	case "TIPO_ESTABLECIMIENTO"
		
		ls_codigo = this.object.TIPO_ESTABLECIMIENTO[row]

		SetNull(ls_data)
		select DESCRIPCION
		  into :ls_data
		  from RRHH_TIPO_ESTABLECIMIENTO_RTPS
		 where TIPO_ESTABLECIMIENTO  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE ESTABLECIMIENTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.TIPO_ESTABLECIMIENTO			[row] = ls_data
			this.object.DESCRIPCION	   [row] = ls_data
			return 1
		end if

		this.object.DESCRIPCION[row] = ls_data
		
	case "COD_EMPRESA"
		
		ls_codigo = this.object.COD_EMPRESA[row]
		
		SetNull(ls_data)
		select nombre
		  into :ls_data
		  from EMPRESA
		 where COD_EMPRESA  = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE EMPRESA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.COD_EMPRESA			[row] = ls_data
			this.object.nombre	         [row] = ls_data
			return 1
		end if
		
		this.object.nombre[row] = ls_data
		
	case "TIPO_VIA"
		
		ls_codigo  = this.object.TIPO_VIA[row]
		ls_empresa = this.object.COD_EMPRESA[row]

		SetNull(ls_data)
		select DESCRIPCION
		  into :ls_data
		  from RRHH_VIAS_RTPS
		 where COD_VIA  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE VIA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.TIPO_VIA			[row] = ls_data
			this.object.descripcion_via	   [row] = ls_data
			return 1
		end if
		
		Select dir_calle
		  into :ls_dir_empresa
	     from empresa
		 where cod_empresa = :ls_empresa;
			
		this.object.descripcion_via[row] = ls_data
		this.object.nombre_via[row] = ls_dir_empresa	
	
	case "TIPO_ZONA"
		
		ls_codigo = this.object.TIPO_ZONA[row]

		SetNull(ls_data)
		select DESCRIPCION
		  into :ls_data
		  from RRHH_ZONAS_RTPS
		 where COD_ZONA  = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "TIPO DE ZONA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.TIPO_ZONA			[row] = ls_data
			this.object.descripcion_zona	   [row] = ls_data
			return 1
		end if

		this.object.descripcion_zona[row] = ls_data
		
	case "COD_CONDI"
		
		ls_codigo = this.object.COD_CONDI[row]

		SetNull(ls_data)
		select DESCRIPCION
		  into :ls_data
		  from RRHH_CONDICION_ESTABLE_RTPS
		 where COD_CONDICION_RPTS  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CONDICION NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.COD_CONDI			[row] = ls_data
			this.object.descripcion_condi	   [row] = ls_data
			return 1
		end if

		this.object.descripcion_condi[row] = ls_data
end choose

end event

