$PBExportHeader$w_cm009_categoria_subcategoria.srw
forward
global type w_cm009_categoria_subcategoria from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cm009_categoria_subcategoria
end type
type st_2 from statictext within w_cm009_categoria_subcategoria
end type
end forward

global type w_cm009_categoria_subcategoria from w_abc_mastdet_smpl
integer width = 3611
integer height = 2032
string title = "Categorias - Sub Categorias [CM009]"
string menuname = "m_mantto_smpl"
st_1 st_1
st_2 st_2
end type
global w_cm009_categoria_subcategoria w_cm009_categoria_subcategoria

on w_cm009_categoria_subcategoria.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_cm009_categoria_subcategoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_modify;call super::ue_modify;int li_protect_categoria, li_protect_subcateg

li_protect_categoria = integer(dw_master.Object.cat_art.Protect)

IF li_protect_categoria = 0 THEN
   dw_master.Object.cat_art.Protect = 1
END IF

li_protect_subcateg = integer(dw_detail.Object.cod_sub_cat.Protect)

IF li_protect_subcateg = 0 THEN
   dw_detail.Object.cod_sub_cat.Protect = 1
END IF




end event

event ue_open_pre;call super::ue_open_pre;
ii_pregunta_delete = 1

if gs_empresa = "SERVIMOTOR" then
	dw_detail.dataObject = 'd_abc_articulo_sub_categ_servimotor_tbl'
else
	dw_detail.dataObject = 'd_abc_articulo_sub_categ_tbl'
end if

dw_detail.SetTransObject(SQLCA)
end event

event resize;// Override 

dw_master.height = newheight - dw_master.y - 10
dw_master.width  = newwidth/2  - dw_master.x - 10

dw_detail.X  = newwidth/2  + 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_1.x = dw_master.x
st_1.width = dw_master.width

st_2.x = dw_detail.x
st_2.width = dw_detail.width
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
if f_row_Processing( dw_detail, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm009_categoria_subcategoria
integer x = 0
integer y = 112
integer width = 1778
integer height = 1648
string dataobject = "d_abc_articulo_categ_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//ib_delete_cascada = true
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_servicio	[al_row] = '0'
this.object.flag_estado		[al_row] = '1'
end event

event dw_master::itemchanged;call super::itemchanged;Long ll_i

this.AcceptText()

if lower(dwo.name) = 'flag_servicio' then
	for ll_i = 1 to dw_detail.RowCount()
		dw_detail.object.flag_servicio[ll_i] = data
		dw_detail.ii_update = 1
	next
end if	
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm009_categoria_subcategoria
integer x = 1815
integer y = 116
integer width = 1778
integer height = 1644
string dataobject = "d_abc_articulo_sub_categ_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 3	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;Return 1		// Fuerza a no mostrar mensaje
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

event dw_detail::ue_insert_pre;//Override

this.object.cat_art			[al_row] = dw_master.object.cat_art 		[dw_master.GetRow()]
this.object.flag_servicio	[al_row] = dw_master.object.flag_servicio [dw_master.GetRow()]
this.object.flag_estado 	[al_row] = '1'

if gs_empresa = 'SERVIMOTOR' then
	this.object.peso_seco 		[al_row] = 0.0
	this.object.peso_bruto 		[al_row] = 0.0
	this.object.pasajeros 		[al_row] = 0.0
	this.object.asientos 		[al_row] = 0.0
	this.object.ejes 				[al_row] = 0.0
	this.object.cilindrada 		[al_row] = 0.0
	this.object.ancho 			[al_row] = 0.0
	this.object.largo 			[al_row] = 0.0
	this.object.alto 				[al_row] = 0.0
	this.object.ruedas 			[al_row] = 0.0
	this.object.carga_util 		[al_row] = 0.0
	this.object.nro_cilindros 	[al_row] = 0.0
end if
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_codbusq
choose case lower(as_columna)
		
	case "cod_marca"

		ls_sql = "select cod_marca as codigo_marca, " &
				 + "nom_marca as nombre_marca " &
				 + "from MARCA " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_marca	[al_row] = ls_codigo
			this.object.nom_marca	[al_row] = ls_data
			this.object.cod_modelo	[al_row] = ""
			this.object.desc_modelo	[al_row] = ""
			this.ii_update = 1
		end if
		
	case "cod_modelo"
		ls_codbusq	= this.object.cod_marca	[al_row]
		if trim(ls_codbusq) = "" or isnull(ls_codbusq) then 
			MessageBox("Error", "Debe de seleccionar una marca, por favor verifique")
			this.object.cod_modelo	[al_row] = gnvo_app.is_null
			this.object.desc_modelo	[al_row] = gnvo_app.is_null
			this.setcolumn("cod_marca")
			return
		end if
		
		ls_sql = "select cod_modelo as codigo_modelo, " &
				 + "desc_modelo as nombre_modelo " &
				 + "from modelo " &
				 + "where flag_estado = '1'" &
				 + "	and cod_marca = '" + ls_codbusq + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_modelo	[al_row] = ls_codigo
			this.object.desc_modelo	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_comb"

		ls_sql = "select cod_comb as codigo_combustible, " &
				 + "comb_desc as descripcion_combustible " &
				 + "from TIPO_COMBUSTIBLE " &
				 + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_comb				[al_row] = ls_codigo
			this.object.desc_combustible	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_carroceria"

		ls_sql = "select cod_carroceria as codigo_carroceria, " &
				 + "carroceria_desc as descripcion_carroceria " &
				 + "from tipo_carroceria " &
				 + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_carroceria				[al_row] = ls_codigo
			this.object.desc_carroceria	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_color"

		ls_sql = "select color as codigo_color, " &
				 + "descripcion as descripcion_color " &
				 + "from color " &
				 + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_color	[al_row] = ls_codigo
			this.object.desc_color	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_clase_vehiculo"
		
		ls_sql = "select cod_clase_vehiculo as codigo_clase, " &
				 + "desc_clase_vehiculo as descripcion_clase " &
				 + "from clase_vehiculo " &
				 + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_clase_vehiculo		[al_row] = ls_codigo
			this.object.desc_clase_vehiculo		[al_row] = ls_data
			this.object.cod_categ_vehiculo		[al_row] = ""
			this.object.desc_categ_vehiculo	[al_row] = ""
			this.ii_update = 1
		end if
	
	case "cod_categ_vehiculo"
		ls_codbusq	= this.object.cod_clase_vehiculo	[al_row]
		if trim(ls_codbusq) = "" or isnull(ls_codbusq) then 
			MessageBox("Error", "Debe de seleccionar una clase de vehículo, por favor verifique")
			this.object.cod_categ_vehiculo		[al_row] = gnvo_app.is_null
			this.object.desc_categ_vehiculo	[al_row] = gnvo_app.is_null
			this.setcolumn("cod_clase_vehiculo")
			return
		end if
		ls_sql = "select cod_categ_vehiculo as codigo_categoria, " &
				 + "desc_categ_vehiculo as descripcion_categoria " &
				 + "from categoria_vehiculo " &
				 + "where flag_Estado = '1'" &
				 + "	and cod_clase_vehiculo = '" + ls_codbusq + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_categ_vehiculo		[al_row] = ls_codigo
			this.object.desc_categ_vehiculo	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose



end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc, ls_codigo
Long 		ll_count

dw_master.Accepttext()
Accepttext()


CHOOSE CASE dwo.name
	CASE 'cod_marca'
		
		// Verifica que codigo ingresado exista			
		Select nom_marca
	     into :ls_desc
		  from MARCA
		 Where UPPER(cod_marca) = UPPER(:data)  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de marca o no se encuentra activo, por favor verifique")
			this.object.cod_marca	[row] = gnvo_app.is_null
			this.object.nom_marca	[row] = gnvo_app.is_null
			this.object.cod_modelo	[row] = gnvo_app.is_null
			this.object.desc_modelo	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_marca		[row] = ls_desc


	CASE 'cod_modelo'
		ls_codigo	= this.object.cod_marca	[row]
		if trim(ls_codigo) = "" or isnull(ls_codigo) then 
			MessageBox("Error", "Debe de seleccionar una marca, por favor verifique")
			this.object.cod_modelo	[row] = gnvo_app.is_null
			this.object.desc_modelo	[row] = gnvo_app.is_null
			this.setcolumn("cod_marca")
			return 1
		end if
		// Verifica que codigo ingresado exista	
		Select desc_modelo
		into :ls_desc
		  from MODELO
		 Where UPPER(cod_modelo)	= UPPER(:data)  
		 	and UPPER(cod_marca)		= UPPER(:ls_codigo)
			and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de modelo o no se encuentra activo, por favor verifique")
			this.object.cod_modelo	[row] = gnvo_app.is_null
			this.object.desc_modelo	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_modelo		[row] = ls_desc
		
	CASE 'cod_comb' 

		// Verifica que codigo ingresado exista			
		Select comb_desc
	     into :ls_desc
		  from TIPO_COMBUSTIBLE
		 Where cod_comb = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de combustible o no se encuentra activo, por favor verifique")
			this.object.cod_comb				[row] = gnvo_app.is_null
			this.object.desc_combustible	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_combustible		[row] = ls_desc

	CASE 'cod_carroceria' 

		// Verifica que codigo ingresado exista			
		Select carroceria_desc
	     into :ls_desc
		  from tipo_carroceria
		 Where cod_carroceria = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Carrocería o no se encuentra activo, por favor verifique")
			this.object.cod_carroceria		[row] = gnvo_app.is_null
			this.object.desc_carroceria	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_carroceria		[row] = ls_desc


	CASE 'cod_color' 

		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from color
		 Where color = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Color o no se encuentra activo, por favor verifique")
			this.object.cod_color	[row] = gnvo_app.is_null
			this.object.desc_color	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_color		[row] = ls_desc
	
	CASE 'cod_clase_vehiculo'
		
		// Verifica que codigo ingresado exista			
		Select desc_clase_vehiculo
	     into :ls_desc
		  from CLASE_VEHICULO
		 Where UPPER(cod_clase_vehiculo) = UPPER(:data)  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de clase vehículo o no se encuentra activo, por favor verifique")
			this.object.cod_clase_vehiculo		[row] = gnvo_app.is_null
			this.object.desc_clase_vehiculo		[row] = gnvo_app.is_null
			this.object.cod_categ_vehiculo		[row] = gnvo_app.is_null
			this.object.desc_categ_vehiculo	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_clase_vehiculo		[row] = ls_desc

	CASE 'cod_categ_vehiculo'
		ls_codigo	= this.object.cod_clase_vehiculo	[row]
		if trim(ls_codigo) = "" or isnull(ls_codigo) then 
			MessageBox("Error", "Debe de seleccionar una clase de vehículo, por favor verifique")
			this.object.cod_categ_vehiculo		[row] = gnvo_app.is_null
			this.object.desc_categ_vehiculo	[row] = gnvo_app.is_null
			this.setcolumn("cod_clase_vehiculo")
			return 1
		end if
		// Verifica que codigo ingresado exista	
		Select desc_categ_vehiculo
		into :ls_desc
		  from CATEGORIA_VEHICULO
		 Where UPPER(cod_categ_vehiculo)	= UPPER(:data)  
		 	and UPPER(cod_clase_vehiculo)	= UPPER(:ls_codigo)
			and flag_estado 			= '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de categoria vahículo o no se encuentra activo, por favor verifique")
			this.object.cod_categ_vehiculo		[row] = gnvo_app.is_null
			this.object.desc_categ_vehiculo	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_categ_vehiculo		[row] = ls_desc

END CHOOSE

end event

type st_1 from statictext within w_cm009_categoria_subcategoria
integer width = 1778
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Categorias"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm009_categoria_subcategoria
integer x = 1815
integer width = 1778
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Sub Categorias"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

