$PBExportHeader$w_ve301_generar_ot.srw
forward
global type w_ve301_generar_ot from w_abc
end type
type pb_cancelar from picturebutton within w_ve301_generar_ot
end type
type pb_aceptar from picturebutton within w_ve301_generar_ot
end type
type dw_detail from u_dw_abc within w_ve301_generar_ot
end type
type dw_master from u_dw_abc within w_ve301_generar_ot
end type
end forward

global type w_ve301_generar_ot from w_abc
integer width = 2985
integer height = 2200
string title = "[VE301] Generar Orden Trabajo"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_generar ( )
event ue_cancelar ( )
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
dw_detail dw_detail
dw_master dw_master
end type
global w_ve301_generar_ot w_ve301_generar_ot

type variables
String	is_nro_ot

str_parametros ist_param
end variables

event ue_generar();string   ls_ot_adm, ls_ot_tipo, ls_cencos_slc, ls_cencos_rsp, 	&
         ls_responsable, ls_titulo, ls_descripcion, 	&
		   ls_cod_proc, ls_desc_proc, ls_flag_programado, 			&
		   ls_flag_costo_tipo, ls_win, ls_mensaje,ls_nro_ov
			
Date     ld_inicio, ld_estimada		
Datetime ldt_fec_reg
integer	li_ok

if dw_detail.RowCount() = 0 then
	f_mensaje('No se ha especificado el detalle para generar la orden de trabajo, por favor verifique o consulte con el area de ventas', '')
	return
end if

ls_ot_adm 				= idw_1.object.ot_adm				[1]
ls_ot_tipo 				= idw_1.object.ot_tipo				[1]
ls_cencos_slc 			= idw_1.object.cencos_slc			[1]
ls_cencos_rsp 			= idw_1.object.cencos_rsp			[1]
ls_responsable			= idw_1.object.responsable			[1]
ld_inicio				= date(idw_1.object.fec_inicio	[1])
ld_estimada				= date(idw_1.object.fec_estimada	[1])
ls_flag_programado	= idw_1.object.flag_programado	[1]
ls_flag_costo_tipo	= idw_1.object.flag_costo_tipo	[1]
ls_titulo				= idw_1.object.titulo				[1]
ls_descripcion			= idw_1.object.descripcion			[1]
ls_nro_ov				= idw_1.object.nro_ov				[1]

ldt_fec_reg	= gnvo_app.of_fecha_actual() 

IF ls_ot_adm = '' or IsNull(ls_ot_adm) THEN
	MessageBox('VENTAS', 'FALTA OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF ls_ot_tipo = '' or IsNull(ls_ot_tipo) THEN
	MessageBox('VENTAS', 'FALTA OT_TIPO, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF


IF ls_cencos_slc = '' or IsNull(ls_cencos_slc) THEN
	MessageBox('VENTAS', 'FALTA CENTRO DE COSTO SOLICITANTE, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF ls_cencos_rsp = '' or IsNull(ls_cencos_rsp) THEN
	MessageBox('VENTAS', 'FALTA CENTRO DE COSTO RESPONSABLE, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF ls_titulo = '' or IsNull(ls_titulo) THEN
	MessageBox('VENTAS', 'FALTA TITULO, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF ls_descripcion = '' or IsNull(ls_descripcion) THEN
	MessageBox('VENTAS', 'FALTA UNA BREVE DESCRIPCION, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF IsNull(ld_inicio) or IsNull(ld_estimada) THEN
	MessageBox('VENTAS', 'FALTAN FECHAS, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

IF ld_estimada < ld_inicio THEN
	MessageBox('VENTAS', 'EL RANGO DE FECHAS ESTA ERRONEO, POR FAVOR VERIFIQUE', stopSign!)
	return
END IF

ls_win       = this.ClassName( )
ls_desc_proc = "GENERACION AUTOMATICA DE ORDENES " &
					+ "DE TRABAJO -> TIPO OT: " + ls_ot_tipo
ls_cod_proc  = "VEGO"




//CREATE OR REPLACE PROCEDURE usp_ve_generar_ot(
//       asi_origen           in  origen.cod_origen%TYPE           ,   -- Codigo de Origen de la O.T.
//       adi_fec_reg          in  orden_trabajo.fec_registro%TYPE  ,   -- Fecha de registro
//       adi_fec_estimada     in  date                             ,   -- Fecha Estimada de Inicio
//       adi_fec_inicio       in  date                             ,   -- Fecha de inicio
//       asi_cencos_rsp       in  orden_trabajo.cencos_rsp%TYPE    ,   -- Centros de Costo Responsable
//       asi_cencos_slc       in  orden_trabajo.cencos_slc%TYPE    ,   -- Centros de Costo solicitante
//       asi_cod_usr          in  usuario.cod_usr%TYPE             ,   -- Codigo de Usuario
//       asi_ot_adm           in  orden_trabajo.ot_adm%TYPE        ,   -- O.T. Administrador
//       asi_ot_tipo          in  orden_trabajo.ot_tipo%TYPE        ,  -- Tipo de O.T.
//       asi_responsable      in  orden_trabajo.responsable%TYPE    ,  -- Responsable de la OT
//       asi_titulo           in  orden_trabajo.titulo%TYPE         ,  -- Titulo de la OT
//       asi_descripcion      in  orden_trabajo.descripcion%TYPE    ,  -- Descripcion de la OT
//       asi_flag_programado  in  orden_trabajo.flag_programado%TYPE,  -- Flag programado
//       asi_flag_costo_tipo  in  orden_trabajo.flag_costo_tipo%TYPE,  -- Flag del tipo de costo
//       asi_cod_proceso      in  oper_procesos.cod_proceso%TYPE    ,  -- Codigo de Proceso
//       asi_desc_proceso     in  oper_procesos.desc_proceso%TYPE   ,  -- descripcion del proceso
//       asi_window           in  oper_procesos.window%TYPE         ,  -- Nombre de la Ventana
//       as_nro_ov            in  orden_venta.nro_ov%TYPE           ,
//       aso_nro_ot           out VARCHAR2  -- Numero de la OT
//) is


DECLARE USP_VE_GENERAR_OT PROCEDURE FOR
  USP_VE_GENERAR_OT(  :gs_origen      		,
							 :ldt_fec_reg   		,
							 :ld_estimada 			,
							 :ld_inicio  			,
							 :ls_cencos_rsp 		,
							 :ls_cencos_slc 		,
							 :gs_user				,
							 :ls_ot_adm  			,
							 :ls_ot_tipo 			,
							 :ls_responsable 		,
							 :ls_titulo 			,
							 :ls_descripcion 		,
							 :ls_flag_programado ,
							 :ls_flag_costo_tipo	, 
							 :ls_cod_proc 			,
							 :ls_desc_proc			,
							 :ls_win 				,
							 :ls_nro_ov				);  
							 
EXECUTE USP_VE_GENERAR_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_VE_GENERAR_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_VE_GENERAR_OT INTO :is_nro_ot;

CLOSE USP_VE_GENERAR_OT;

MessageBox('VENTAS', 'PROCESO EJECUTADO DE MANERA SATISFACTORIA', Exclamation!)	

ist_param.titulo = 's'
ist_param.string1 = is_nro_ot
   
CloseWithReturn(This, ist_param)


end event

event ue_cancelar;ist_param.titulo = 'n'
   
CloseWithReturn(This, ist_param)
end event

on w_ve301_generar_ot.create
int iCurrent
call super::create
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancelar
this.Control[iCurrent+2]=this.pb_aceptar
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_master
end on

on w_ve301_generar_ot.destroy
call super::destroy
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;date   ld_fecha
String ls_nro_ov

ld_fecha = Date(gnvo_app.of_fecha_actual( ))

ist_param = Message.PowerObjectParm

idw_1 = dw_master
idw_1.event dynamic ue_insert()

idw_1.object.flag_estado		[1] = ist_param.string3
idw_1.object.flag_programado	[1] = '1'
idw_1.object.flag_costo_tipo	[1] = 'V'
idw_1.object.fec_estimada		[1] = ld_fecha
idw_1.object.fec_inicio			[1] = ld_fecha
idw_1.object.nro_ov				[1] = ist_param.string1
//dw_1.SetTransObject(sqlca)

dw_detail.SetTransObject(sqlca)
dw_detail.Retrieve( )

end event

event ue_set_access;//Override 
end event

event close;call super::close;
ist_param.titulo = 's'
   
CloseWithReturn(This, ist_param)

end event

type pb_cancelar from picturebutton within w_ve301_generar_ot
integer x = 1454
integer y = 1868
integer width = 361
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\CLOSE_UP.BMP"
alignment htextalign = left!
end type

event clicked;close(Parent)
end event

type pb_aceptar from picturebutton within w_ve301_generar_ot
integer x = 923
integer y = 1868
integer width = 361
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_generar()
end event

type dw_detail from u_dw_abc within w_ve301_generar_ot
event ue_display ( string as_columna,  long al_row )
integer y = 1140
integer width = 2953
integer height = 712
integer taborder = 20
string dataobject = "d_list_plant_prod_art_tbl"
end type

event ue_display;Boolean 	lb_ret
String 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
			ls_icoterm, ls_cod_art
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	
	CASE 'cod_plantilla'
		
		ls_icoterm = ist_param.string2
		ls_cod_art = This.object.cod_Art 			  [al_row]
		
		ls_sql = "SELECT PPA.COD_PLANTILLA AS CODIGO, " &
				  +" PP.DESC_PLANTILLA AS DESCRIPCION " &
				  +"FROM   PLANT_PROD_ARTICULO PPA, " &
				  + "PLANT_PROD PP " &
				  + "WHERE  PPA.COD_PLANTILLA = PP.COD_PLANTILLA " &
				  + "AND   COD_ART  = '" + ls_cod_art + "'" &
				  + "AND   INCOTERM = '" + ls_icoterm + "'" 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_plantilla	[al_row] = ls_codigo
			This.object.desc_plantilla	[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'centro_benef'
		
		ls_cod_art = This.object.cod_Art 			  [al_row]
		
		ls_sql =  "SELECT CBA.CENTRO_BENEF AS CODIGO, " &
				  + "CB.DESC_CENTRO AS DESCRIPCION "     &
				  + "FROM   CENTRO_BENEF_ARTICULO CBA, "  &
				  + "CENTRO_BENEFICIO CB " &
				  + "WHERE CBA.CENTRO_BENEF = CB.CENTRO_BENEF " &
				  + "AND   flag_estado = '1'" 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.centro_benef	[al_row] = ls_codigo
			This.ii_update = 1
		END IF
END CHOOSE

end event

event constructor;call super::constructor;is_dwform = 'tabular'	

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type dw_master from u_dw_abc within w_ve301_generar_ot
event ue_display ( string as_columna,  long al_row )
integer width = 2953
integer height = 1128
string dataobject = "d_ve_generar_ot_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_otadm
str_seleccionar lstr_seleccionar

CHOOSE CASE upper(as_columna)
		
	CASE "OT_ADM"
		
		ls_sql = "SELECT OT_ADM AS CODIGO, "		&
				  + "DESCRIPCION AS DESC_OT_ADM " 	&
				  + "FROM vw_ot_adm_user " 			&
				  + "WHERE COD_USR = '" + gs_user +"'"

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.ot_adm		[al_row] = ls_codigo
			This.object.desc_ot_adm	[al_row] = ls_data
			SetNull(ls_data)
 			This.object.ot_tipo		[al_row] = ls_data
			This.object.desc_ot_tipo[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE "OT_TIPO"
		ls_otadm = This.object.ot_adm[al_row]
		
		IF ls_otadm = '' OR IsNull(ls_otadm) THEN
			MessageBox('APROVISIONAMIENTO', 'NO SE INDICADO UN OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
			Return
		END IF
		
		ls_sql = "SELECT OT_TIPO AS CODIGO, " 		&
				  + "DESCRIPCION AS DESC_OT_TIPO " 	&
				  + "FROM ot_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.ot_tipo		[al_row]	= ls_codigo
			This.object.desc_ot_tipo[al_row] = ls_data
			This.ii_update = 1	
		END IF
	
	CASE "CENCOS_SLC"

		ls_sql = "SELECT CENCOS AS CODIGO, " 	 &
			    + "DESC_CENCOS AS DESC_OT_TIPO " &
				 + "FROM CENTROS_COSTO " 			 &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos_slc		[al_row] = ls_codigo
			This.object.desc_cencos_slc[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE "CENCOS_RSP"

		ls_sql = "SELECT CENCOS AS CODIGO, " &
			    + "DESC_CENCOS AS DESC_OT_TIPO " &
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos_rsp		[al_row]	= ls_codigo
			This.object.desc_cencos_rsp[al_row] = ls_data
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
			This.object.titulo			[al_row] = ls_data
			This.object.descripcion		[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE 'RESPONSABLE'
		ls_sql = "SELECT M.COD_TRABAJADOR AS CODIGO, " 	 &
				 + "P.NOM_PROVEEDOR AS NOMBRE " 				 &
				 + "FROM MAESTRO M, PROVEEDOR P "			 &	
				 + "WHERE M.COD_TRABAJADOR = P.PROVEEDOR " & 
				 + "AND P.FLAG_ESTADO = '1'"
												 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.responsable		[al_row] = ls_codigo
			This.object.nom_proveedor	[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE "CENTRO_BENEF"
		
		ls_sql   = "SELECT distinct a.CENTRO_BENEF AS centro_beneficio, "&
				   + "a.DESC_centro AS DESCRIPCION_centro,u.cod_usr "&
				   + "FROM centro_beneficio a, centro_benef_usuario u " &
				   + "WHERE a.FLAG_ESTADO = '1' " &
					+ "AND A.CENTRO_BENEF = U.CENTRO_BENEF "&
					+ "and u.cod_usr = '" + gs_user + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.centro_benef		[al_row] = ls_codigo

			this.ii_update = 1
		END IF

END CHOOSE
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if



end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_data, ls_codigo, ls_otadm, ls_null,ls_desc

SetNull(ls_null)
This.AcceptText()

IF row = 0 THEN
	Return
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "OT_ADM"
		SELECT DESCRIPCION 
			INTO :ls_data
		FROM  vw_ot_adm_user
		WHERE COD_USR = :gs_user
		  and ot_adm = :data;
		
		IF SQLCA.SQLcode = 100 THEN
			MessageBox('VENTAS', 'CODIGO DE OT_ADM NO EXISTE O NO ESTA AUTORIZADO', stopSign!)			
			This.object.ot_adm		[row] = ls_null
			This.object.desc_ot_adm	[row] = ls_null
 			This.object.ot_tipo		[row] = ls_null
			This.object.desc_ot_tipo[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_ot_adm	[row] = ls_data
		
		This.object.ot_tipo		[row] = ls_null
		This.object.desc_ot_tipo[row] = ls_null
		
	CASE "OT_TIPO"
		ls_otadm = this.object.ot_adm[row]
		
		IF ls_otadm = '' OR IsNull(ls_otadm) THEN
			MessageBox('APROVISIONAMIENTO', 'NO SE INDICADO UN OT_ADM, POR FAVOR VERIFIQUE', stopSign!)
			RETURN 1
		END IF

		SELECT DESCRIPCION
		  INTO :ls_data
		FROM ot_tipo
		WHERE ot_tipo = :data;
		
		IF SQLCA.SQLcode = 100 THEN
			MessageBox('VENTAS', 'CODIGO DE OT_TIPO NO EXISTE O NO ESTA AUTORIZADO', stopSign!)
			This.object.ot_tipo		[row]	= ls_null
			This.object.desc_ot_tipo[row] = ls_null
			Return 1
		END IF
		 
		This.object.desc_ot_tipo[row] = ls_data

	CASE "CENCOS_SLC"
		SELECT DESC_CENCOS
			INTO :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :data;

		IF SQLCA.SQLcode = 100 THEN
			MessageBox('VENTAS', 'CODIGO DE CENTRO DE COSTO SOLICITANTE NO EXISTE O NO ESTA ACTIVO', stopSign!)			
 			This.object.cencos_slc		[row] = ls_null
			This.object.desc_cencos_slc[row] = ls_null
			Return 1
		END IF
		
		This.object.desc_cencos_slc[row] = ls_data

	CASE "CENCOS_RSP"
		SELECT DESC_CENCOS
			into :ls_data
		FROM CENTROS_COSTO
		WHERE FLAG_ESTADO = '1'
		  and cencos = :data;

		IF SQLCA.sqlcode = 100 THEN
			MessageBox('VENTAS', 'CODIGO DE CENTRO DE COSTO REPONSABLE NO EXISTE O NO ESTA ACTIVO', stopSign!)
 			This.object.cencos_rsp		[row] = ls_null
			This.object.desc_cencos_rsp[row] = ls_null
			Return 1
		END IF

		This.object.desc_cencos_rsp[row] = ls_data

	CASE "COD_PLANTILLA"
		SELECT DESC_PLANTILLA
			INTO :ls_data
		FROM vw_plant_ot_adm
	  	WHERE FLAG_ESTADO = '1'
		  and cod_plantilla = :data;
		  
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('VENTAS', 'CODIGO DE PLANTILLA NO EXISTE, NO ESTA ACTIVO O TIENE AUTORIZACION', stopSign!)
			This.object.cod_plantilla	[row] = ls_null
			This.object.desc_plantilla	[row] = ls_null
			Return 1
		END IF

		This.object.desc_plantilla	[row] = ls_data
		This.object.titulo			[row] = ls_data
		This.object.descripcion		[row] = ls_data
	
	CASE "RESPONSABLE"
		SELECT NOM_PROVEEDOR
			INTO :ls_data
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor   = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('VENTAS', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.responsable		[row] = ls_null
			THIS.object.nom_proveedor	[row] = ls_null
			RETURN 1
		END IF

		THIS.Object.nom_proveedor 	[row] = ls_data
	CASE "CENTRO_BENEF"
		
		select a.desc_centro
		  into :ls_desc
		  from centro_beneficio a, centro_benef_usuario u
		 where a.centro_benef = :data
		   and u.centro_benef = a.centro_benef
		   and a.flag_estado = '1'
			and u.cod_usr = :gs_user;

		IF SQLCA.SQLCode = 100 THEN
			This.Object.centro_benef    	[row] = ls_null

			Messagebox('Aviso','Centro de Beneficios no existe, no se encuentra activo u su usuario no esta relacionado a èste Centro de Beneficio ' &
				+ ', por favor verifique')
			RETURN 1
		END IF
		

			

END CHOOSE


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

