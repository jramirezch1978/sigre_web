$PBExportHeader$w_sr003_und_operat.srw
forward
global type w_sr003_und_operat from w_abc_master_smpl
end type
end forward

global type w_sr003_und_operat from w_abc_master_smpl
integer height = 1064
string title = "(SR003) Maestro de Unidades Operativas"
string menuname = "m_mtto_smpl"
end type
global w_sr003_und_operat w_sr003_und_operat

on w_sr003_und_operat.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr003_und_operat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type ole_skin from w_abc_master_smpl`ole_skin within w_sr003_und_operat
end type

type st_1 from w_abc_master_smpl`st_1 within w_sr003_und_operat
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr003_und_operat
end type

type st_box from w_abc_master_smpl`st_box within w_sr003_und_operat
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr003_und_operat
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr003_und_operat
string dataobject = "d_abc_und_operat_grd"
end type

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc, ls_mensaje

This.AcceptText()
if row = 0 then return
Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
	CASE 'empresa'

		SELECT NOMBRE_EMPRESA
			INTO :ls_desc
		FROM mae_empresa
   	WHERE  empresa = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				ls_mensaje = 'Codigo de empresa ' + data + ' no existe o no está activo'
				gnvo_app.of_showmessagedialog( ls_mensaje )
				gnvo_log.of_errorlog( ls_mensaje )
			else
				ls_mensaje = gnvo_log.of_mensajedb( "Error en buscar datos en empresa")
				gnvo_app.of_showmessagedialog( ls_mensaje )
				gnvo_log.of_errorlog( ls_mensaje )
			end if
			this.Object.empresa			[row] = ls_null
			this.object.nom_empresa		[row] = ls_null
			this.setcolumn( "empresa" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.nom_empresa [row] = ls_desc
		
	CASE 'cod_origen'

		SELECT desc_origen
			INTO :ls_desc
		FROM mae_origen
   	WHERE  origen = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				ls_mensaje = 'Codigo de origen ' + data + ' no existe o no está activo'
				gnvo_app.of_showmessagedialog( ls_mensaje )
				gnvo_log.of_errorlog( ls_mensaje )
			else
				ls_mensaje = gnvo_log.of_mensajedb( "Error en buscar datos en mae_origen")
				gnvo_app.of_showmessagedialog( ls_mensaje )
				gnvo_log.of_errorlog( ls_mensaje )
			end if
			this.Object.cod_origen		[row] = ls_null
			this.object.desc_origen		[row] = ls_null
			this.setcolumn( "cod_origen" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_origen [row] = ls_desc
		
END CHOOSE

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "empresa"
		ls_sql = "SELECT empresa AS CODIGO_empresa, " &
				  + "nombre_empresa AS nombre_empresa " &
				  + "FROM mae_empresa " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.empresa		[al_row] = ls_codigo
			this.object.nom_empresa	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_origen"
		ls_sql = "SELECT origen AS CODIGO_origen, " &
				  + "DESC_origen AS DESCRIPCION_origen " &
				  + "FROM mae_origen " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.desc_origen	[al_row] = ls_data
			this.ii_update = 1
		end if
	
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
end event

