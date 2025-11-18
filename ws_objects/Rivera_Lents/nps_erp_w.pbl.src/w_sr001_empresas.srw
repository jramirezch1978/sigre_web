$PBExportHeader$w_sr001_empresas.srw
forward
global type w_sr001_empresas from w_abc_master_smpl
end type
end forward

global type w_sr001_empresas from w_abc_master_smpl
integer width = 2843
integer height = 1808
string title = "[SR001] Maestro de Empresas"
string menuname = "m_mtto_smpl"
end type
global w_sr001_empresas w_sr001_empresas

on w_sr001_empresas.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr001_empresas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_duplicar;//Override
Long  ll_row

if idw_1.RowCount() = 0 then
	idw_1.Event ue_duplicar()

else
	gnvo_app.of_showmessagedialog( "Solamente está permitido un solo registro" )
end if

end event

type p_pie from w_abc_master_smpl`p_pie within w_sr001_empresas
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sr001_empresas
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr001_empresas
end type

type st_box from w_abc_master_smpl`st_box within w_sr001_empresas
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sr001_empresas
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sr001_empresas
end type

type p_logo from w_abc_master_smpl`p_logo within w_sr001_empresas
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr001_empresas
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr001_empresas
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr001_empresas
string dataobject = "d_abc_empresas_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_cntrl_cd	[al_row] = '0'
this.object.flag_estado		[al_row] = '1'
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_pais, ls_cod_dpto, ls_cod_prov, &
			ls_cod_distr

choose case lower(as_columna)
		
	case "cod_actividad"
		ls_sql = "SELECT cod_actividad AS codigo_actividad, " &
				  + "DESC_ACTIVIDAD AS descripcion_actividada " &
				  + "FROM rrhh_actividad_rtps " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_Actividad	[al_row] = ls_codigo
			this.object.desc_actividad	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_doc_ident"
		ls_sql = "SELECT TIPO_DOC_RTPS AS tipo_doc, " &
				  + "DESC_TIPO_DOC_RTPS AS desc_tipo_doc " &
				  + "FROM rrhh_tipo_doc_rtps " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_ident			[al_row] = ls_codigo
			this.object.desc_tipo_doc_ident	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "ciu_cod_pais"
		ls_sql = "SELECT cod_pais AS codigo_pais, " &
				  + "nom_pais AS nombre_pais " &
				  + "FROM pais " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ciu_cod_pais[al_row] = ls_codigo
			this.object.nom_pais		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "ciu_cod_dpto"
		ls_cod_pais = this.object.ciu_cod_pais [al_row]
		
		if ls_cod_pais = '' or IsNull(ls_cod_pais) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un país" )	
			this.setColumn('ciu_cod_pais')
			return
		end if
		
		ls_sql = "SELECT cod_dpto AS codigo_departamento, " &
				  + "desc_dpto AS descripcion_departamento " &
				  + "FROM departamento_estado " &
				  + "where flag_Estado = '1' " &
				  + "and cod_pais = '" + ls_cod_pais + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ciu_cod_dpto		[al_row] = ls_codigo
			this.object.desc_departamento	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "ciu_cod_prov"
		ls_cod_pais = this.object.ciu_cod_pais [al_row]
		
		if ls_cod_pais = '' or IsNull(ls_cod_pais) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un país" )	
			this.setColumn('ciu_cod_pais')
			return
		end if
		
		ls_cod_dpto = this.object.ciu_cod_dpto [al_row]
		
		if ls_cod_dpto = '' or IsNull(ls_cod_dpto) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un departamento" )	
			this.setColumn('ciu_cod_dpto')
			return
		end if

		ls_sql = "SELECT cod_prov AS codigo_provincia, " &
				  + "desc_prov AS descripcion_provincia " &
				  + "FROM provincia_condado " &
				  + "where flag_Estado = '1' " &
				  + "and cod_pais = '" + ls_cod_pais + "' " &
				  + "and cod_dpto = '" + ls_cod_dpto + "' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ciu_cod_prov	[al_row] = ls_codigo
			this.object.desc_provincia	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "ciu_cod_distr"
		ls_cod_pais = this.object.ciu_cod_pais [al_row]
		
		if ls_cod_pais = '' or IsNull(ls_cod_pais) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un país" )	
			this.setColumn('ciu_cod_pais')
			return
		end if
		
		ls_cod_dpto = this.object.ciu_cod_dpto [al_row]
		
		if ls_cod_dpto = '' or IsNull(ls_cod_dpto) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un departamento" )	
			this.setColumn('ciu_cod_dpto')
			return
		end if

		ls_cod_prov = this.object.ciu_cod_prov [al_row]
		
		if ls_cod_prov = '' or IsNull(ls_cod_prov) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero una provincia" )	
			this.setColumn('ciu_cod_prov')
			return
		end if

		ls_sql = "SELECT COD_DISTR AS codigo_distrito, " &
				  + "DESC_DISTRITO AS descripcion_distrito " &
				  + "FROM distrito " &
				  + "where flag_Estado = '1' " &
				  + "and cod_pais = '" + ls_cod_pais + "' " &
				  + "and cod_dpto = '" + ls_cod_dpto + "' " &
				  + "and cod_prov = '" + ls_cod_prov + "' " &
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ciu_cod_distr	[al_row] = ls_codigo
			this.object.desc_distrito	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_ciudad"
		ls_cod_pais = this.object.ciu_cod_pais [al_row]
		
		if ls_cod_pais = '' or IsNull(ls_cod_pais) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un país" )	
			this.setColumn('ciu_cod_pais')
			return
		end if
		
		ls_cod_dpto = this.object.ciu_cod_dpto [al_row]
		
		if ls_cod_dpto = '' or IsNull(ls_cod_dpto) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un departamento" )	
			this.setColumn('ciu_cod_dpto')
			return
		end if

		ls_cod_prov = this.object.ciu_cod_prov [al_row]
		
		if ls_cod_prov = '' or IsNull(ls_cod_prov) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero una provincia" )	
			this.setColumn('ciu_cod_prov')
			return
		end if

		ls_cod_distr = this.object.ciu_cod_distr [al_row]
		
		if ls_cod_distr = '' or IsNull(ls_cod_distr) then
			gnvo_app.of_showmessagedialog( "Debe elegir primero un distrito" )	
			this.setColumn('ciu_cod_distr')
			return
		end if

		ls_sql = "SELECT COD_ciudad AS codigo_ciudad, " &
				  + "DESCR_CIUDAD AS descripcion_ciudad " &
				  + "FROM ciudad " &
				  + "where flag_Estado = '1' " &
				  + "and cod_pais = '" + ls_cod_pais + "' " &
				  + "and cod_dpto = '" + ls_cod_dpto + "' " &
				  + "and cod_prov = '" + ls_cod_prov + "' " &
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_ciudad	[al_row] = ls_codigo
			this.object.desc_ciudad	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::buttonclicked;call super::buttonclicked;string ls_docpath, ls_docname
integer i, li_cnt, li_rtn, li_filenum

if row = 0 then return

if dwo.name = 'b_logo' then

	li_rtn = GetFileOpenName("Seleccione Imagen", &
		ls_docpath, ls_docname, "jpg", &
		+ "Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg", &
		"i:\pb_exe", 18)
	
	IF li_rtn < 1 THEN return
	
	this.object.logo[row] = ls_docpath
	this.ii_update = 1
	
end if
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc, ls_mensaje

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_responsable'
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from usuario
		 Where cod_usr = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de usuario ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cod_responsable[row] = ls_null
			this.object.nom_usuario		[row] = ls_null
			return 1
		end if

		this.object.nom_usuario		[row] = ls_desc
		

CASE 'cencos' 
		// Verifica que centro_costo exista
		Select desc_cencos
	     into :ls_desc
		  from centros_costo
		  Where cencos = :data 
		    and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Centro de Costo ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)

			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null			
			return 1
		end if

		this.object.desc_cencos[row] = ls_desc
		
	CASE "cod_origen" 
		//Verifica que exista dato ingresado	
		Select nombre
	     into :ls_desc
		  from origen
		  Where cod_origen = :data 
		    and flag_estado = '1';
					
		If SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Origen ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cod_origen	[row] = ls_null
			this.object.nom_origen	[row] = ls_null
			return 1
		end if
			
		this.object.nom_origen	[row] = ls_desc

END CHOOSE


end event

