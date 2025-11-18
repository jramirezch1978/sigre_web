$PBExportHeader$w_sg010_user_empresas.srw
forward
global type w_sg010_user_empresas from w_abc_mastdet_smpl
end type
end forward

global type w_sg010_user_empresas from w_abc_mastdet_smpl
string title = "[SG010] Usuarios x Empresa"
end type
global w_sg010_user_empresas w_sg010_user_empresas

on w_sg010_user_empresas.create
int iCurrent
call super::create
end on

on w_sg010_user_empresas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insert;//Ancestor Override
Long  ll_row

IF idw_1 = dw_master THEN
	RETURN
END IF

ib_insert_check= true
this.event ue_insert_pre( )

if not ib_insert_check then return

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

type p_pie from w_abc_mastdet_smpl`p_pie within w_sg010_user_empresas
end type

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_sg010_user_empresas
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_sg010_user_empresas
end type

type st_box from w_abc_mastdet_smpl`st_box within w_sg010_user_empresas
end type

type phl_logonps from w_abc_mastdet_smpl`phl_logonps within w_sg010_user_empresas
end type

type p_mundi from w_abc_mastdet_smpl`p_mundi within w_sg010_user_empresas
end type

type p_logo from w_abc_mastdet_smpl`p_logo within w_sg010_user_empresas
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_sg010_user_empresas
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_sg010_user_empresas
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_sg010_user_empresas
end type

type dw_master from w_abc_mastdet_smpl`dw_master within w_sg010_user_empresas
string dataobject = "d_list_empresas_activas_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 2 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sg010_user_empresas
integer width = 2167
integer height = 576
string dataobject = "d_abc_usuario_empresa_tbl"
end type

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro[al_row] = f_fecha_actual(0)

this.setColumn("cod_usr")
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_usr"
		ls_sql = "SELECT COD_USR AS codigo_usuario, " &
				  + "NOMBRE AS nombre_usuario " &
				  + "FROM usuario " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_origen"

		ls_sql = "SELECT cod_origen AS codigo_origen, " &
				  + "NOMBRE AS descripcion_origen " &
				  + "FROM origen " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if
	
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[1] = 2				// columnas de lectrua de este dw
ii_ck[1] = 4				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_null, ls_desc, ls_mensaje

this.Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_usr'
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
			
			this.object.cod_usr		[row] = ls_null
			this.object.nom_usuario	[row] = ls_null
			return 1
		end if

		this.object.nom_usuario		[row] = ls_desc
		
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

