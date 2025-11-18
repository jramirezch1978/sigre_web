$PBExportHeader$w_rh240_basc_programa_capacitacion.srw
forward
global type w_rh240_basc_programa_capacitacion from w_abc_mastdet_smpl
end type
end forward

global type w_rh240_basc_programa_capacitacion from w_abc_mastdet_smpl
integer y = 360
integer width = 3628
integer height = 1882
string title = "(RH240) Programacion de cursos para Capacitación"
string menuname = "m_master_simple"
end type
global w_rh240_basc_programa_capacitacion w_rh240_basc_programa_capacitacion

type variables
integer ii_dw_upd //variable de actualizacion del dw 
integer ii_flag    //flag de actualizar tablas
end variables

on w_rh240_basc_programa_capacitacion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh240_basc_programa_capacitacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)



end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )

long ll_row
ll_row = dw_master.getrow()
if ll_row > 0 then
	dw_master.object.cantidad_part[ll_row] = dw_detail.rowcount()
	dw_master.ii_update = 1
end if

//Verificación de Data en Detalle de Otras Cuentas Bancarias
IF gnvo_app.of_row_Processing( dw_master ) <> true then
	dw_master.SetFocus()
	return
END IF

//Verificación de Data en Detalle de Otras Cuentas Bancarias
IF gnvo_app.of_row_Processing( dw_detail ) <> true then
	dw_detail.SetFocus()
	return
END IF
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh240_basc_programa_capacitacion
integer x = 29
integer y = 26
integer width = 3544
integer height = 822
string dataobject = "d_ope_basc_prog_curso_cab"
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// Columnas de lectrua del dw
ii_ck[2] = 2			// Columnas de lectrua de este dw
ii_dk[1] = 1 	      // Columnas que se pasan al detalle
ii_dk[2] = 2			// Columnas de lectrua de este dw


is_dwform = 'grid'	// tabular, form (default)
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear


end event

event dw_master::ue_output;//override
//THIS.EVENT ue_retrieve_det(al_row)


dw_detail.retrieve(this.object.cod_curso[al_row],date(this.object.fec_curso[al_row]))
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())
dw_master.Modify("cod_curso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fec_curso.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::clicked;call super::clicked;ii_dw_upd = 1 //Variable de actualizacion para el dw Maestro

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh240_basc_programa_capacitacion
integer x = 29
integer y = 870
integer width = 3544
integer height = 848
string dataobject = "d_ope_basc_prog_curso_det"
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// Columnas de lectrua de este dw
ii_ck[2] = 2			// Columnas de lectrua de este dw

ii_rk[1] = 1 	      // Columnas que recibimos del master
ii_rk[2] = 2	
end event

event dw_detail::itemchanged;call super::itemchanged;idw_1 = this
idw_1.GetText()
idw_1.AcceptText()
string ls_desc, ls_null
setnull(ls_null)
if dwo.name = 'tipo_doc_ident' then
				
				select descripcion into :ls_desc
				  from rrhh_documento_identidad_rtps
				 where cod_doc_identidad = trim(:data);
				
				if sqlca.sqlcode = 100 then
					
					this.object.tipo_doc_ident  [row] = ls_null
					this.object.descripcion [row] = ls_null
					Messagebox(this.title, 'Tipo de Documento Inexistente')
					Return 1
				else
					this.object.descripcion [row] = ls_desc
				end if
elseif dwo.name = 'nro_doc_ident' then
	
	long i
	for i = 1 to this.rowcount()
		if trim(this.object.nro_doc_ident[i]) = trim(data) and i <> row then
			MessageBox('Aviso','Numero de documento ya esta ingresado')
			this.object.nro_doc_ident[row] = ''
			return 1
		end if
	end for
	
	if this.object.tipo_doc_ident[row] = '01' then
		
		select RTRIM(MAESTRO.APEL_PATERNO)||' '||RTRIM(MAESTRO.APEL_MATERNO)||' '||NVL(RTRIM(MAESTRO.NOMBRE1),' ')||' '||NVL(RTRIM(MAESTRO.NOMBRE2),' ')
		  into :ls_desc
		  from maestro
		 where dni = :data;
		
		if sqlca.sqlcode = 0 then
			this.object.nombre[row] = ls_desc
			return 1
		end if
		
	end if
	
end if

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = gs_user

//Registros Anteriores del Datawindow Detalle
dw_detail.Modify("tipo_doc_ident.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("nro_doc_ident.Protect='1~tIf(IsRowNew(),0,1)'")

setcolumn('tipo_doc_ident')
end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2 //Variable de actualizacion del dw detalle
end event

event dw_detail::doubleclicked;call super::doubleclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2
	if dwo.name = 'tipo_doc_ident' then
		ls_sql = "select cod_doc_identidad as codigo, descripcion as descripcion from rrhh_documento_identidad_rtps where flag_estado='1'" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.tipo_doc_ident [row] = ls_return1
				this.object.descripcion[row] = ls_return2
				this.ii_update = 1
	end if
end if
end event

event dw_detail::ue_insert;call super::ue_insert;setcolumn('tipo_doc_ident')

return 1
end event

