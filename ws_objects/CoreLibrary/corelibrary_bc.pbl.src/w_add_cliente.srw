$PBExportHeader$w_add_cliente.srw
forward
global type w_add_cliente from w_abc
end type
type shl_2 from statichyperlink within w_add_cliente
end type
type shl_1 from statichyperlink within w_add_cliente
end type
type cb_cancelar from commandbutton within w_add_cliente
end type
type cb_aceptar from commandbutton within w_add_cliente
end type
type dw_master from u_dw_abc within w_add_cliente
end type
end forward

global type w_add_cliente from w_abc
integer width = 3205
integer height = 1944
string title = "Añadir un nuevo Cliente"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
shl_2 shl_2
shl_1 shl_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_add_cliente w_add_cliente

type variables
str_parametros 	istr_param
n_cst_utilitario	invo_util
n_cst_wait			invo_wait
end variables

event ue_aceptar;str_parametros lstr_param

String 	ls_nom_proveedor, ls_tipo_doc_ident, ls_nro_doc_ident, ls_flag_clie_prov, &
			ls_flag_nac_ext, ls_mensaje, ls_proveedor, ls_flag_personeria, ls_ruc, &
			ls_apellido_pat, ls_apellido_mat, ls_nombre1, ls_nombre2
Long		ll_count, ll_ult_nro, ll_item	

//Direccion
String 	ls_descripcion, ls_dir_direccion, ls_dir_direccion2, ls_dir_distrito, &
			ls_dir_provincia, ls_dir_dep_estado, ls_dir_pais, ls_dir_siglas_pais, &
			ls_dir_ciudad, ls_dir_urbanizacion, ls_dir_mnz, ls_dir_lote, ls_dir_interior, &
			ls_dir_numero, ls_dir_cod_postal, ls_dir_referencia, ls_email

//Valido los datos requeridos
dw_master.AcceptText()
if not gnvo_app.of_row_Processing( dw_master ) then return

//Obtengo los datos necesarios
ls_nom_proveedor 	= dw_master.object.nom_proveedor 	[1]
ls_tipo_doc_ident = dw_master.object.tipo_doc_ident 	[1]
ls_nro_doc_ident 	= dw_master.object.nro_doc_ident 	[1]
ls_flag_clie_prov = dw_master.object.flag_clie_prov 	[1]
ls_flag_nac_ext 	= dw_master.object.flag_nac_ext 		[1]
ls_apellido_pat 	= dw_master.object.apellido_pat 		[1]
ls_apellido_mat 	= dw_master.object.apellido_mat 		[1]
ls_nombre1 			= dw_master.object.nombre1 			[1]
ls_nombre2 			= dw_master.object.nombre2 			[1]
ls_email				= dw_master.object.email 				[1]

//Datos de la direccion
ls_descripcion 		= dw_master.object.descripcion 			[1]
ls_dir_direccion 		= dw_master.object.dir_direccion 		[1]
ls_dir_direccion2 	= dw_master.object.dir_direccion2 		[1]
ls_dir_distrito 		= dw_master.object.dir_distrito 			[1]
ls_dir_provincia 		= dw_master.object.dir_provincia 		[1]
ls_dir_dep_estado 	= dw_master.object.dir_dep_estado 		[1]
ls_dir_pais 			= dw_master.object.dir_pais 				[1]
ls_dir_siglas_pais 	= dw_master.object.dir_siglas_pais 		[1]
ls_dir_ciudad 			= dw_master.object.dir_ciudad 			[1]
ls_dir_urbanizacion 	= dw_master.object.dir_urbanizacion 	[1]
ls_dir_mnz 				= dw_master.object.dir_mnz 				[1]
ls_dir_lote 			= dw_master.object.dir_lote 				[1]
ls_dir_interior 		= dw_master.object.dir_interior 			[1]
ls_dir_numero 			= dw_master.object.dir_numero 			[1]
ls_dir_cod_postal 	= dw_master.object.dir_cod_postal 		[1]
ls_dir_referencia 	= dw_master.object.dir_referencia 		[1]


//Valido los datos
if IsNull(ls_nom_proveedor) or trim(ls_nom_proveedor) = '' then
	messageBox("Error", "Debe ingresar el nombre del cliente o su razon social. Por favor verifique!", StopSign!)
	dw_master.setColumn("nom_proveedor")
	return
end if

if IsNull(ls_tipo_doc_ident) or trim(ls_tipo_doc_ident) = '' then
	messageBox("Error", "Debe ingresar el Tipo de Documento de Identidad. Por favor verifique!", StopSign!)
	dw_master.setColumn("tipo_doc_ident")
	return
end if

if IsNull(ls_nro_doc_ident) or trim(ls_nro_doc_ident) = '' then
	messageBox("Error", "Debe ingresar el Numero de Documento de Identidad. Por favor verifique!", StopSign!)
	dw_master.setColumn("nro_doc_ident")
	return
end if

if IsNull(ls_email) or trim(ls_email) = '' then
	messageBox("Error", "Debe ingresar el Correo Electrónico del Cliente para enviarle su comprobante electronico. Por favor verifique!", StopSign!)
	dw_master.setColumn("email")
	return
end if

if ls_tipo_doc_ident = '6' and (IsNull(ls_nom_proveedor) or trim(ls_nom_proveedor) = '') then
	messageBox("Error", "Debe ingresar la razon social o nombre comercial. Por favor verifique!", StopSign!)
	dw_master.setColumn("nom_proveedor")
	return
end if

//Valido los datos de la direccion
if IsNull(ls_descripcion) or trim(ls_descripcion) = '' then
	MessageBox('Error', 'Debe Ingresar la DESCRIPCION de la Direccion del cliente', StopSign!)
	dw_master.SetColumn("descripcion")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_direccion) or trim(ls_dir_direccion) = '' then
	MessageBox('Error', 'Debe Ingresar la DIRECCION 1 del cliente', StopSign!)
	dw_master.SetColumn("dir_direccion")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_pais) 	or trim(ls_dir_pais) = '' then
	MessageBox('Error', 'Debe Ingresar el PAIS del cliente', StopSign!)
	dw_master.SetColumn("dir_pais")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_dep_estado) or trim(ls_dir_dep_estado) = '' then
	MessageBox('Error', 'Debe Ingresar el DEPARTAMENTO del cliente', StopSign!)
	dw_master.SetColumn("dir_dep_estado")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_provincia) or trim(ls_dir_provincia) = '' then
	MessageBox('Error', 'Debe Ingresar la PROVINCIA del cliente', StopSign!)
	dw_master.SetColumn("dir_provincia")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_distrito) or trim(ls_dir_distrito) = '' then
	MessageBox('Error', 'Debe Ingresar el DISTRITO  del cliente', StopSign!)
	dw_master.SetColumn("dir_distrito")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_ciudad) or trim(ls_dir_ciudad) = '' then
	MessageBox('Error', 'Debe Ingresar la CIUDAD del cliente', StopSign!)
	dw_master.SetColumn("dir_ciudad")
	dw_master.SetFocus()
	return
end if	

if IsNull(ls_dir_siglas_pais) or trim(ls_dir_siglas_pais) = '' then
	MessageBox('Error', 'Debe Ingresar las SIGLAS del PAIS del cliente', StopSign!)
	dw_master.SetColumn("dir_siglas_pais")
	dw_master.SetFocus()
	return
end if	

if ls_tipo_doc_ident <> '6' then
	
	ls_flag_personeria = 'N'
	
elseif mid(ls_nro_doc_ident, 1, 1) = '1' then
	
	ls_flag_personeria = 'N'
	
else
	
	ls_flag_personeria = 'J'
	
end if

//VAlido los datos del Cliente
if ls_tipo_doc_ident <> '6' OR ls_flag_personeria = 'N' then

	if IsNull(ls_apellido_pat) or trim(ls_apellido_pat) = '' then
		messageBox("Error", "Debe ingresar el apellido paterno del cliente. Por favor verifique!", StopSign!)
		dw_master.setColumn("apellido_pat")
		return
	end if
	
	if IsNull(ls_apellido_mat) or trim(ls_apellido_mat) = '' then
		messageBox("Error", "Debe ingresar el apellido materno del cliente. Por favor verifique!", StopSign!)
		dw_master.setColumn("apellido_mat")
		return
	end if
	
	if IsNull(ls_nombre1) or trim(ls_nombre1) = '' then
		messageBox("Error", "Debe ingresar el primer nombre del cliente. Por favor verifique!", StopSign!)
		dw_master.setColumn("nombre1")
		return
	end if
end if

	

//Validando datos de la direccion
if (IsNull(ls_descripcion) 			or trim(ls_descripcion) = '')	 		&
  and (IsNull(ls_dir_direccion2) 	or trim(ls_dir_direccion2) = '') 	&
  and (IsNull(ls_dir_direccion) 		or trim(ls_dir_direccion) = '') 		&
  and (IsNull(ls_dir_distrito) 		or trim(ls_dir_distrito) = '') 		&
  and (IsNull(ls_dir_provincia) 		or trim(ls_dir_provincia) = '') 		&
  and (IsNull(ls_dir_dep_estado) 	or trim(ls_dir_dep_estado) = '') 	&	 
  and (IsNull(ls_dir_pais) 			or trim(ls_dir_pais) = '') 			&
  and (IsNull(ls_dir_ciudad) 			or trim(ls_dir_ciudad) = '') 			&
  and (IsNull(ls_dir_urbanizacion) 	or trim(ls_dir_urbanizacion) = '') 	&
  and (IsNull(ls_dir_mnz) 				or trim(ls_dir_mnz) = '') 				&
  and (IsNull(ls_dir_lote) 			or trim(ls_dir_lote) = '') 			&
  and (IsNull(ls_dir_interior) 		or trim(ls_dir_interior) = '') 		&
  and (IsNull(ls_dir_numero) 			or trim(ls_dir_numero) = '') 			&
  and (IsNull(ls_dir_cod_postal)		or trim(ls_dir_cod_postal) = '') 	&
  and (IsNull(ls_dir_referencia) 	or trim(ls_dir_referencia) = '') then
	
	MessageBox('Error', 'Debe Ingresar alguna direccion del cliente', StopSign!)
	return
	
end if	

//Valido la longitud
if ls_tipo_doc_ident = '6' then
	if len(trim(ls_nro_doc_ident)) <> 11 then
		MessageBox('Error', 'El RUC debe ser de 11 dígitos por favor verifique', StopSign!)
		dw_master.setColumn("nro_doc_ident")
		return
	end if
end if

//DNI
if ls_tipo_doc_ident = '1' then
	if len(trim(ls_nro_doc_ident)) <> 8 then
		MessageBox('Error', 'El DNI debe ser de 8 dígitos por favor verifique', StopSign!)
		dw_master.setColumn("nro_doc_ident")
		return
	end if
end if


//Valido si el documento ya existe
if ls_tipo_doc_ident = '6' then
	
	
	
	select count(*)
		into :ll_count
	from proveedor
	where tipo_doc_ident = :ls_tipo_doc_ident
	  and ruc				= :ls_nro_doc_ident;
	  
else
	
	select count(*)
		into :ll_count
	from proveedor
	where tipo_doc_ident = :ls_tipo_doc_ident
	  and nro_doc_ident	= :ls_nro_doc_ident;
	
end if

if ll_count > 0 then
	messageBox('Error', 'El documento de identidad ya ha sido ingresado, por favor verifique!', StopSign!)
	return
end if

//Confirmo la grabación de los datos
if MessageBox('Pregunta', '¿Desea guardar los datos ingresados del cliente?', Information!, Yesno!, 2) = 2 then return

//Obtengo el numero del siguiente proveedor
select ult_nro
	into :ll_ult_nro
from num_proveedor
where origen = 'XX' for update;

if SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
	
	insert into num_proveedor(ult_nro, origen)
	values(1, 'XX');
	
	if SQLCA.SQLcode < 0 then
		ls_mensaje = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al insertar en tabla num_proveedor. Error: ' + ls_mensaje, StopSign!)
		return
	end if
	
end if

ls_proveedor = 'E' + trim(string(ll_ult_nro, '0000000'))

//Actualizo el numerador
update num_proveedor
   set ult_nro = :ll_ult_nro + 1
where origen = 'XX';

if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al actualizar la tabla num_proveedor. Error: ' + ls_mensaje, StopSign!)
	return
end if

//Inserto el cliente
if ls_tipo_doc_ident = '6' then
	ls_ruc = ls_nro_doc_ident
	ls_nro_doc_ident = ''
else
	ls_ruc = ''
end if



insert into proveedor(
	proveedor, flag_estado, flag_trabajador, flag_clie_prov, flag_tipo_precio, tipo_proveedor, &
	nom_proveedor, ruc, flag_personeria, cod_usr, flag_ret_igv, flag_nac_ext, tipo_doc_ident, &
	nro_doc_ident, apellido_pat, apellido_mat, nombre1, nombre2, email)
values(
	:ls_proveedor, '1', '0', :ls_flag_clie_prov, '2', '01', &
	:ls_nom_proveedor, :ls_ruc, :ls_flag_personeria, :gs_user, '1', :ls_flag_nac_ext, :ls_tipo_doc_ident, &
	:ls_nro_doc_ident, :ls_apellido_pat, :ls_apellido_mat, :ls_nombre1, :ls_nombre2, :ls_email);

if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al Insertar la tabla proveedor. Error: ' + ls_mensaje, StopSign!)
	return
end if

//Inserto la direccion
select nvl(max(item), 0)
	into :ll_item
from direcciones
where codigo = :ls_proveedor;

if IsNull(ll_item) then ll_item = 0

ll_item ++

insert into direcciones(
	codigo, descripcion, dir_pais, dir_dep_estado, dir_provincia, dir_ciudad, dir_distrito, &
	dir_urbanizacion, dir_direccion, dir_mnz, dir_lote, dir_numero, flag_uso, item, &
	flag_dir_comercial, dir_direccion2, dir_referencia, dir_interior, dir_siglas_pais)
values(
	:ls_proveedor, :ls_descripcion, :ls_dir_pais, :ls_dir_dep_estado, :ls_dir_provincia, :ls_dir_ciudad, :ls_dir_distrito, &
	:ls_dir_urbanizacion, :ls_dir_direccion, :ls_dir_mnz, :ls_dir_lote, :ls_dir_numero, '3', :ll_item, &
	'0', :ls_dir_direccion2, :ls_dir_referencia, :ls_dir_interior, :ls_dir_siglas_pais);
	
if SQLCA.SQLcode < 0 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al Insertar la tabla direcciones. Error: ' + ls_mensaje, StopSign!)
	return
end if
	
commit;

lstr_param.b_return 	= true
lstr_param.string1	= ls_proveedor

CloseWithReturn(this, lstr_param)
end event

on w_add_cliente.create
int iCurrent
call super::create
this.shl_2=create shl_2
this.shl_1=create shl_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_2
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.cb_cancelar
this.Control[iCurrent+4]=this.cb_aceptar
this.Control[iCurrent+5]=this.dw_master
end on

on w_add_cliente.destroy
call super::destroy
destroy(this.shl_2)
destroy(this.shl_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;istr_param 	= Message.Powerobjectparm
invo_wait	= create n_cst_Wait

dw_master.event ue_insert()
end event

event close;call super::close;destroy invo_wait
end event

type shl_2 from statichyperlink within w_add_cliente
integer x = 2519
integer y = 24
integer width = 635
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "Consultar en SUNAT >>"
boolean focusrectangle = false
end type

event clicked;String 			ls_tipo_doc_ident, ls_nro_doc_ident, ls_dir_direccion, ls_string []
Integer 			li_count
BeanPadronRUC 	lnvo_bean
str_parametros	lstr_return

try 
	dw_master.Accepttext()
	
	
	ls_tipo_doc_ident = dw_master.object.tipo_doc_ident 	[1]
	ls_nro_doc_ident	= dw_master.object.nro_doc_ident 	[1]
	
	if IsNull(ls_tipo_doc_ident) or trim(ls_tipo_doc_ident) = "" then
		dw_master.object.nro_doc_ident [1] = gnvo_app.is_null
		MessageBox('Error', 'Debe indicar primero un tipo de documento de identidad, verifique!', StopSign!)
		dw_master.SetColumn('tipo_doc_ident')
		return 1
	end if
	
	if ls_tipo_doc_ident <>'6' then
		MessageBox('Error', 'Solo puede buscar en SUNAT documentos de tipo RUC, por favor verifique!', StopSign!)
		dw_master.SetColumn('tipo_doc_ident')
		return 1
	end if
	
	select count(*)
		into :li_count
	from proveedor
	where decode(:ls_tipo_doc_ident, '6', ruc, nro_doc_ident) = :ls_nro_doc_ident;
	
	if SQLCA.SQLCode < 0 then
		dw_master.object.nro_doc_ident [1] = gnvo_app.is_null
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla PROVEEDOR. Mensaje ' &
			+ SQLCA.SQLErrText + ', por favor verifique!', StopSign!)
		dw_master.SetColumn('tipo_doc_ident')
		return 1
	end if
	
	if li_count > 0 then
		MessageBox('Error', 'El RUC ' + ls_nro_doc_ident &
								+ ' ya esta registrado en la base de datos, ' &
								+ 'por favor confirma y corrija', StopSign!)
		return 1
	end if
	
	if MessageBox('Error', '¿Desea que busque el RUC ' + ls_nro_doc_ident + ' en el Servidor de SUNAT?. ' &
								+ 'Tenga presente que la busqueda puede demorar algunos minutos', &
								Information!, Yesno!, 1) = 1 then
		
		invo_wait.of_mensaje("Espere un momento, procesando Servicio Web de SUNAT")
		
		lnvo_bean = gnvo_app.logistica.of_leer_ruc_externo(ls_nro_doc_ident)
		
		invo_wait.of_mensaje("Datos Obtenidos, validando informacion")
		
		if not lnvo_bean.isOK then
			dw_master.object.nro_doc_ident [1] = gnvo_app.is_null
			MessageBox('Error', 'Error al consultar RUC en sunat. Mensaje: ' + lnvo_bean.mensaje, StopSign!)
			return 1
		end if
		
		if trim(lnvo_bean.estado) <> 'ACTIVO' then
			if MessageBox('Error', 'El RUC ' + ls_nro_doc_ident + ' no se encuentra ACTIVO.' &
										+ '~r~nEstado Real: ' + trim(lnvo_bean.estado) &
										+ '~r~n¿Desea cotinuar con los datos de SUNAT?', Information!, YesNo!, 2) = 2 then
				return 1
			end if
		end if
		
		if trim(lnvo_bean.condicion) <> 'HABIDO' then
			if MessageBox('Error', 'El RUC ' + ls_nro_doc_ident + ' no se encuentra HABIDO.' &
										+ '~r~Condicion Real: ' + trim(lnvo_bean.condicion) &
										+ '~r~n¿Desea cotinuar con los datos de SUNAT?', Information!, YesNo!, 2) = 2 then
				return 1
			end if
		end if
		
		invo_wait.of_mensaje("Informacion Validada, llenando formulario...")
		
		//Relleno los datos necesarios
		dw_master.object.nom_proveedor 	[1] = lnvo_bean.razonSocial
		dw_master.object.descripcion 		[1] = 'OFICINA PRINCIPAL'
		
		dw_master.object.dir_distrito 	[1] = lnvo_bean.descDistrito
		dw_master.object.dir_provincia 	[1] = lnvo_bean.descDistrito
		dw_master.object.dir_dep_estado 	[1] = lnvo_bean.descDepartamento
		dw_master.object.dir_ciudad	 	[1] = lnvo_bean.descDistrito
		dw_master.object.dir_pais		 	[1] = 'PERU'
		
		dw_master.object.dir_urbanizacion[1] = ''
		dw_master.object.dir_numero		[1] = ''
		dw_master.object.dir_interior		[1] = ''
		dw_master.object.dir_lote			[1] = ''
		dw_master.object.dir_mnz			[1] = ''
		
		//Si es una persona natural
		if mid(ls_nro_doc_ident,1,1) = '1' then
			lstr_return = invo_util.of_split(lnvo_bean.razonSocial, ' ')
			
			ls_string = lstr_return.str_array
			
			if upperBound(ls_string) >= 1 then
				dw_master.object.apellido_pat	[1] = ls_string [1]
			end if
			
			if upperBound(ls_string) >= 2 then
				dw_master.object.apellido_mat	[1] = ls_string [2]
			end if
			
			if upperBound(ls_string) >= 3 then
				dw_master.object.nombre1		[1] = ls_string [3]
			end if
			
			if upperBound(ls_string) >= 4 then
				dw_master.object.nombre2		[1] = ls_string [4]
			end if
			
			dw_master.object.flag_personeria	[1] = 'N'
			
		else
			dw_master.object.apellido_pat		[1] = ''
			dw_master.object.apellido_mat		[1] = ''
			dw_master.object.nombre1			[1] = ''
			dw_master.object.nombre2			[1] = ''
			
			dw_master.object.flag_personeria	[1] = 'J'
		end if
		
		ls_dir_direccion = ''
		
		if lnvo_bean.tipoVia <> '-' and trim(lnvo_bean.tipoVia) <> '' then
			ls_dir_direccion += lnvo_bean.tipoVia + ' '
		end if
		
		if lnvo_bean.nombreVia <> '-' and trim(lnvo_bean.nombreVia) <> '' then
			ls_dir_direccion += lnvo_bean.nombreVia + ' '
		end if
		
		if lnvo_bean.codigoZona <> '-' and trim(lnvo_bean.codigoZona) <> '' then
			
			if lnvo_bean.codigoZona = 'URB.' then
			
				dw_master.object.dir_urbanizacion	[1] = lnvo_bean.tipoZona
			
			else
				
				ls_dir_direccion += lnvo_bean.tipoZona + ' ' + lnvo_bean.codigoZona + ' '
				
			end if
			
		end if
		
		dw_master.object.dir_direccion 	[1] = trim(ls_dir_direccion)
		
		if lnvo_bean.numero <> '-' and trim(lnvo_bean.numero) <> '' then
			dw_master.object.dir_numero	[1] = lnvo_bean.numero
		end if
		
		if lnvo_bean.interior <> '-' and trim(lnvo_bean.interior) <> '' then
			dw_master.object.dir_interior	[1] = lnvo_bean.interior
		end if
		
		if lnvo_bean.lote <> '-' and trim(lnvo_bean.lote) <> '' then
			dw_master.object.dir_lote	[1] = lnvo_bean.lote
		end if
		
		if lnvo_bean.manzana <> '-' and trim(lnvo_bean.manzana) <> '' then
			dw_master.object.dir_mnz	[1] = lnvo_bean.manzana
		end if
		
		invo_wait.of_mensaje("Proceso concluido satisfactoriamente")
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en busqueda de RUC en SUNAT')
	
finally
	invo_Wait.of_close()
	
end try

end event

type shl_1 from statichyperlink within w_add_cliente
integer x = 2437
integer y = 1656
integer width = 727
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "Abrir Pagina de SUNAT >>"
alignment alignment = right!
boolean focusrectangle = false
string url = "http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias"
end type

type cb_cancelar from commandbutton within w_add_cliente
integer x = 1637
integer y = 1668
integer width = 498
integer height = 164
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type cb_aceptar from commandbutton within w_add_cliente
integer x = 1129
integer y = 1668
integer width = 498
integer height = 164
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

type dw_master from u_dw_abc within w_add_cliente
integer width = 3163
integer height = 1648
string dataobject = "d_abc_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_insert_pre;call super::ue_insert_pre;if not IsNull(istr_param) and IsValid(istr_param) then
	if istr_param.tipo_doc = gnvo_app.finparam.is_doc_fac then
		this.object.tipo_doc_ident 	[al_row] = '6'
	else
		this.object.tipo_doc_ident 	[al_row] = '1'
	end if
else
	this.object.tipo_doc_ident 	[al_row] = '6'
end if

this.object.flag_clie_prov		[al_row] = '0'
this.object.flag_nac_ext		[al_row] = 'N'
this.object.flag_personeria	[al_row] = 'J'
this.object.dir_siglas_pais	[al_row] = 'PE'

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_insert;//Override
long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo

END IF

RETURN ll_row
end event

event editchanged;call super::editchanged;String ls_razon_social, ls_apellido_pat, ls_apellido_mat, ls_nombre1, ls_nombre2

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'apellido_pat', 'apellido_mat', 'nombre1', 'nombre2'
		
		ls_apellido_pat 	= this.object.apellido_pat [row]
		ls_apellido_mat 	= this.object.apellido_mat [row]
		ls_nombre1 			= this.object.nombre1 		[row]
		ls_nombre2 			= this.object.nombre2 		[row]
		
		if ISNull(ls_apellido_pat) then ls_apellido_pat = ''
		if ISNull(ls_apellido_mat) then ls_apellido_mat = ''
		if ISNull(ls_nombre1) then ls_nombre1 = ''
		if ISNull(ls_nombre2) then ls_nombre2 = ''
		
		ls_razon_social = trim(trim(ls_apellido_pat) + ' ' + trim(ls_apellido_mat)) + ', ' + trim(trim(ls_nombre1) + ' ' + trim(ls_nombre2))
		

		this.object.nom_proveedor			[row] = ls_razon_social
		
		return 1

END CHOOSE
end event

