$PBExportHeader$w_cm010_articulos.srw
forward
global type w_cm010_articulos from w_abc
end type
type tab_1 from tab within w_cm010_articulos
end type
type tabpage_1 from userobject within tab_1
end type
type cb_upload from commandbutton within tabpage_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type p_foto from picture within tabpage_1
end type
type pb_resize from picturebutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_upload cb_upload
dw_master dw_master
p_foto p_foto
pb_resize pb_resize
end type
type tabpage_2 from userobject within tab_1
end type
type dw_indicadores from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_indicadores dw_indicadores
end type
type tabpage_12 from userobject within tab_1
end type
type dw_und_adicionales from u_dw_abc within tabpage_12
end type
type tabpage_12 from userobject within tab_1
dw_und_adicionales dw_und_adicionales
end type
type tabpage_8 from userobject within tab_1
end type
type dw_datos_tecnicos from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_datos_tecnicos dw_datos_tecnicos
end type
type tabpage_6 from userobject within tab_1
end type
type dw_equivalencias from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_equivalencias dw_equivalencias
end type
type tabpage_10 from userobject within tab_1
end type
type dw_art_composicion from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_art_composicion dw_art_composicion
end type
type tabpage_11 from userobject within tab_1
end type
type dw_art_bonific from u_dw_abc within tabpage_11
end type
type tabpage_11 from userobject within tab_1
dw_art_bonific dw_art_bonific
end type
type tabpage_3 from userobject within tab_1
end type
type dw_saldos from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_saldos dw_saldos
end type
type tabpage_4 from userobject within tab_1
end type
type dw_ubicacion from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_ubicacion dw_ubicacion
end type
type tabpage_5 from userobject within tab_1
end type
type dw_saldos_almacen from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_saldos_almacen dw_saldos_almacen
end type
type tabpage_7 from userobject within tab_1
end type
type dw_precios_pactados from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_precios_pactados dw_precios_pactados
end type
type tabpage_9 from userobject within tab_1
end type
type dw_centro_benef from u_dw_abc within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_centro_benef dw_centro_benef
end type
type tab_1 from tab within w_cm010_articulos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_12 tabpage_12
tabpage_8 tabpage_8
tabpage_6 tabpage_6
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
tabpage_9 tabpage_9
end type
type st_1 from statictext within w_cm010_articulos
end type
end forward

global type w_cm010_articulos from w_abc
integer width = 4443
integer height = 2260
string title = "[CM010] Maestro de Articulos"
string menuname = "m_mantto_smpl"
boolean resizable = false
tab_1 tab_1
st_1 st_1
end type
global w_cm010_articulos w_cm010_articulos

type variables
u_dw_abc 		idw_master, idw_indicadores, idw_datos_tecnicos, idw_ubicacion, &
					idw_saldos_almacen, idw_equivalencias, idw_precios_pactados, &
					idw_saldos, idw_centro_benef, idw_art_composicion, idw_art_bonific, &
					idw_und_adicionales
					
decimal			ldc_PRECIO_CMP_REF
blob 				ibl_imagen
Picture			ip_foto
PictureButton	ipb_resize
n_cst_wait		invo_wait

n_cst_utilitario	invo_util
end variables

forward prototypes
public subroutine of_retrieve (string as_cod_art)
public subroutine of_set_modify ()
public function integer of_set_cambios ()
public function integer of_get_param ()
public subroutine of_actualizar ()
public subroutine of_asigna_dws ()
public function boolean of_articulo_venta ()
public function decimal of_ult_precio_comp (string as_cod_art, string as_cod_moneda)
end prototypes

public subroutine of_retrieve (string as_cod_art);
String	ls_mensaje
//Maestro
idw_master.retrieve(as_cod_art)


//Max Tamao del Cod_art
if gnvo_app.logistica.il_tam_max_cod_art > 0 then
	idw_master.object.cod_art.edit.Limit = gnvo_app.logistica.il_tam_max_cod_art
end if

yield()

if idw_master.RowCount() > 0 then
	
	//SetMicroHelp("Un momento cargando la foto del artículo....")
	yield()
	invo_wait.of_mensaje("Un momento cargando la foto del artículo....")
	yield()
	
	//Coloco la foto
	selectBLOB imagen 
		into :ibl_imagen 
	from articulo 
	where cod_art = :as_cod_art;
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consulta la tabla ARTICULO: ' &
						+ ls_mensaje, StopSign!)
		return
	end if
	
	if IsNull(ibl_imagen) then
		ipb_resize.visible = false
		
		//SetMicroHelp("")
		yield()
		invo_wait.of_mensaje("Registo no tiene foto....")
		ip_foto.PictureName = gnvo_app.is_noimagen
		yield()
		
	else
		ip_foto.SetRedraw(FALSE)
		ip_foto.SetPicture(ibl_imagen)
		ip_foto.SetRedraw(TRUE)
		
		ipb_resize.visible = true
		
		//SetMicroHelp("")
		yield()
		invo_wait.of_mensaje("Foto Cargada....")
		yield()
	end if
	
	
	
end if

yield()

// lee dw_ubicacion
idw_ubicacion.retrieve( as_cod_art)	
// Lee los saldos 
idw_saldos_almacen.retrieve( as_cod_art)

// Lee los equivalentes
idw_equivalencias.retrieve( as_cod_art)	

//Lee los precios pactados
idw_precios_pactados.retrieve( as_cod_art)	
idw_ubicacion.Retrieve(as_cod_art)
idw_centro_benef.Retrieve(as_cod_art)

idw_art_composicion.retrieve( as_cod_art)	
idw_art_bonific.Retrieve(as_cod_art)
idw_und_adicionales.Retrieve(as_cod_art)


idw_master.ii_update = 0
idw_master.ii_protect = 0
idw_master.of_protect()


idw_saldos.ii_update = 0
idw_saldos.ii_protect = 0
idw_saldos.of_protect()

idw_datos_tecnicos.ii_update = 0
idw_datos_tecnicos.ii_protect = 0
idw_datos_tecnicos.of_protect()

idw_indicadores.ii_update = 0
idw_indicadores.ii_protect = 0
idw_indicadores.of_protect()

idw_ubicacion.ii_update = 0
idw_ubicacion.ii_protect = 0
idw_ubicacion.of_protect()

idw_saldos_almacen.ii_update = 0
idw_saldos_almacen.ii_protect = 0
idw_saldos_almacen.of_protect()

idw_equivalencias.ii_update = 0
idw_equivalencias.ii_protect = 0
idw_equivalencias.of_protect()

idw_precios_pactados.ii_update = 0
idw_precios_pactados.ii_protect = 0
idw_precios_pactados.of_protect()

idw_centro_benef.ii_update = 0
idw_centro_benef.ii_protect = 0
idw_centro_benef.of_protect()

idw_art_composicion.ii_update = 0
idw_art_composicion.ii_protect = 0
idw_art_composicion.of_protect()

idw_art_bonific.ii_update = 0
idw_art_bonific.ii_protect = 0
idw_art_bonific.of_protect()

idw_und_adicionales.ii_update = 0
idw_und_adicionales.ii_protect = 0
idw_und_adicionales.of_protect()


//
idw_master.ResetUpdate()
idw_saldos.ResetUpdate()
idw_datos_tecnicos.ResetUpdate()
idw_indicadores.ResetUpdate()
idw_ubicacion.ResetUpdate()
idw_saldos_almacen.ResetUpdate()
idw_equivalencias.ResetUpdate()
idw_precios_pactados.ResetUpdate()
idw_centro_benef.ResetUpdate()

idw_art_composicion.ResetUpdate()
idw_art_bonific.ResetUpdate()
idw_und_adicionales.ResetUpdate()


is_action = 'open'
//Aplicar los cambios en los campos de acuerdo a los flags
this.of_set_cambios( )
//of_actualizar()

yield()
invo_wait.of_mensaje("Datos Cargados.....")
yield()

invo_wait.of_close()
end subroutine

public subroutine of_set_modify ();//Saldo minimo
idw_ubicacion.Modify("sldo_minimo.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubicacion.Modify("sldo_minimo.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

//Saldo Maximo
idw_ubicacion.Modify("sldo_maximo.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubicacion.Modify("sldo_maximo.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

//Cantidad a Comprar
idw_ubicacion.Modify("cnt_compra_rec.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubicacion.Modify("cnt_compra_rec.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

idw_ubicacion.SetColumn('ubicacion')
end subroutine

public function integer of_set_cambios ();string 	ls_flag_reposicion, ls_flag_und2, ls_flag_critico
Long		ll_row

if is_action <> 'open' then return 0

if idw_indicadores.GetRow() = 0 then return 0

ll_row = idw_indicadores.GetRow()

ls_flag_reposicion = idw_indicadores.object.flag_reposicion	[ll_row]
ls_flag_critico	 = idw_indicadores.object.flag_critico		[ll_row]
ls_flag_und2	 	 = idw_indicadores.object.flag_und2			[ll_row]

if isNull(ls_flag_reposicion) then 
	ls_flag_reposicion = '0'
	idw_indicadores.object.flag_reposicion	[ll_row]
	idw_indicadores.ii_update = 1
end if

if isNull(ls_flag_critico) then 
	ls_flag_critico = '0'
	idw_indicadores.object.flag_critico	[ll_row]
	idw_indicadores.ii_update = 1
end if

if isNull(ls_flag_und2) then 
	ls_flag_critico = '0'
	idw_indicadores.object.flag_und2	[ll_row]
	idw_indicadores.ii_update = 1
end if

// Si tiene activo el fla reposicion, entonces 
// no es necesario activar los campos, porque ya los 
// tiene activo
	
if ls_flag_und2 = '0' then
	idw_indicadores.Object.und2.Protect = 1
	idw_indicadores.Object.factor_conv_und.Protect = 1
	idw_indicadores.object.und2.edit.required = 'Yes'
	idw_indicadores.object.factor_conv_und.EditMask.required = 'Yes'
else
	idw_indicadores.Object.und2.Protect = 0
	idw_indicadores.Object.factor_conv_und.Protect = 0
	idw_indicadores.object.und2.edit.required = 'No'
	idw_indicadores.object.factor_conv_und.EditMask.required = 'No'
end if

return 1

end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

try 
	
	// busca tipos de movimiento definidos
	SELECT 	NVL(PRECIO_CMP_REF, -1)
		INTO 	:ldc_precio_cmp_ref
	FROM logparam 
	where reckey = '1';
	
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "no ha definido parametros en Logparam")
		return 0
	end if
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error", "Error al consultar la tabla LOGPARAM. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if
	

return 1

catch ( Exception ex)
	ls_mensaje = ex.getMessage()
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido una excepcion. Mensaje: ' + ex.getMessage(), StopSign!)
	return 0	
end try


end function

public subroutine of_actualizar ();String 	ls_cod_art, ls_moneda_compra
Decimal	ldc_old_precio, ldc_ult_prec_comp

ls_moneda_compra = idw_saldos.object.moneda_compra [idw_saldos.getRow()]
if ls_moneda_compra = '' or IsNull(ls_moneda_compra) then 
	MessageBox('Aviso', 'Debe Especificar una moneda para el precio de ult compra', StopSign!)
	idw_saldos.SetColumn('moneda_compra')
	idw_saldos.setFocus()
	return
end if


ls_cod_art = idw_saldos.object.cod_Art [idw_saldos.GetRow()]
if ls_cod_art = '' or IsNull(ls_cod_art) then 
	MessageBox('Aviso', 'Codigo de Articulo no definido, por favor verifique!', StopSign!)
	return
end if

ldc_old_precio = dec(idw_saldos.object.costo_ult_compra[idw_saldos.GetRow()])

ldc_ult_prec_comp = of_ult_precio_comp(ls_cod_art, ls_moneda_compra)

if IsNull(ldc_ult_prec_comp) then ldc_ult_prec_comp = ldc_precio_cmp_ref

if ldc_old_precio <> ldc_ult_prec_comp then
	MessageBox('Aviso', 'Actualizando Precio de Ultima Compra en Dolares')
	idw_saldos.object.costo_ult_compra[idw_saldos.GetRow()] = ldc_ult_prec_comp
	idw_saldos.ii_update = 1
end if
end subroutine

public subroutine of_asigna_dws ();idw_master 				= tab_1.tabpage_1.dw_master
idw_indicadores		= tab_1.tabpage_2.dw_indicadores
idw_saldos				= tab_1.tabpage_3.dw_saldos
idw_datos_tecnicos	= tab_1.tabpage_8.dw_datos_tecnicos
idw_ubicacion			= tab_1.tabpage_4.dw_ubicacion
idw_saldos_almacen	= tab_1.tabpage_5.dw_saldos_almacen
idw_equivalencias		= tab_1.tabpage_6.dw_equivalencias
idw_precios_pactados	= tab_1.tabpage_7.dw_precios_pactados
idw_centro_benef		= tab_1.tabpage_9.dw_centro_benef
idw_art_composicion	= tab_1.tabpage_10.dw_art_composicion
idw_art_bonific		= tab_1.tabpage_11.dw_art_bonific
idw_und_adicionales	= tab_1.tabpage_12.dw_und_adicionales


ip_foto 					= tab_1.tabpage_1.p_foto
ipb_resize				= tab_1.tabpage_1.pb_resize
end subroutine

public function boolean of_articulo_venta ();Integer	li_count
String 	ls_clase, ls_cod_art, ls_mensaje

try 
	if idw_master.RowCount() = 0 then 
		return false
	end if
	
	ls_clase 	= idw_master.object.cod_clase 	[1]
	ls_cod_art	= idw_master.object.cod_art		[1]
	
	if trim(ls_clase) = trim(gnvo_app.of_get_parametro("CLASE_PPTT", "01")) then
		select count(*)
			into :li_count
		from articulo_venta 
		where cod_art = :ls_cod_art;
		
		if li_count = 0 then
			if MessageBox('Aviso', 'El articulo ' + ls_cod_art &
				+ ' es producto terminado, Desea insertarlo como ARTICULO DE VENTA?', Information!, &
				Yesno!, 2) = 2 then 
				
				return true
				
			end if
			
			insert into articulo_venta(cod_art)
			values(:ls_cod_art);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha ocurrido un error al insertar tabla ARTICULO_VENTA. Mensaje: ' &
							+ ls_mensaje, StopSign!) 
				return false
			end if
			
		end if
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
finally
	
end try


end function

public function decimal of_ult_precio_comp (string as_cod_art, string as_cod_moneda);String	ls_mensaje
decimal	ldc_prec_ult_comp

//begin
//  -- Call the function
//  :result := pkg_logistica.of_get_ult_precio_compra(asi_cod_art => :asi_cod_art,
//                                                    asi_cod_moneda => :asi_cod_moneda);
//end;

DECLARE of_get_ult_precio_compra PROCEDURE FOR
	pkg_logistica.of_get_ult_precio_compra( :as_cod_art,
														 :as_cod_moneda);

EXECUTE of_get_ult_precio_compra;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION pkg_logistica.of_get_ult_precio_compra(). Mensaje: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return gnvo_app.idc_null
END IF

FETCH of_get_ult_precio_compra INTO :ldc_prec_ult_comp;
CLOSE of_get_ult_precio_compra;

return ldc_prec_ult_comp


end function

on w_cm010_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.tab_1=create tab_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.st_1
end on

on w_cm010_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

invo_wait = create n_cst_wait

idw_1 = idw_master

idw_master.SetTransObject(SQLCA)
idw_saldos_almacen.SetTransObject(SQLCA)
idw_ubicacion.SetTransObject(SQLCA)
idw_equivalencias.SetTransObject(SQLCA)
idw_precios_pactados.SetTransObject(SQLCA)
idw_centro_benef.SetTransObject(SQLCA)

idw_master.of_protect() 
idw_indicadores.of_protect() 
idw_datos_tecnicos.of_protect() 
idw_saldos.of_protect() 
idw_equivalencias.of_protect()
idw_precios_pactados.of_protect()
idw_ubicacion.of_protect( )
idw_centro_benef.SetTransObject(SQLCA)

ii_pregunta_delete = 1 
// ii_help = 101           // help topic

// Busco primer registro 
String ls_cod_art

Select s.cod_art 
	into :ls_cod_art 
from (select * from articulo order by fec_registro desc) s
where rownum = 1;

of_retrieve(ls_cod_art)
end event

event ue_insert;call super::ue_insert;Long  ll_row
string ls_cod_art

this.event ue_update_request()

if idw_1 = idw_master then
	
	idw_master.reset()
	idw_ubicacion.Reset()
	idw_datos_tecnicos.Reset()
	idw_indicadores.Reset()
	idw_saldos.Reset()
	idw_saldos_almacen.Reset()
	idw_equivalencias.Reset()
	idw_precios_pactados.Reset()
	idw_centro_benef.Reset()
	
	idw_art_composicion.Reset()
	idw_art_bonific.Reset()
	idw_und_adicionales.Reset()

	ll_row = idw_master.Event ue_insert()
	IF ll_row <> -1 THEN
		idw_indicadores.ii_protect = 1
		idw_indicadores.of_protect()
		THIS.EVENT ue_insert_pos(ll_row)
		is_Action = 'new'
		idw_master.setColumn('cat_art')
	end if

elseif idw_1 = idw_centro_benef then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_centro_benef.event ue_insert()
	
elseif idw_1 = idw_equivalencias then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_equivalencias.event ue_insert()
	
elseif idw_1 = idw_precios_pactados then	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if

	idw_precios_pactados.event ue_insert()

elseif idw_1 = idw_art_composicion then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_art_composicion.event ue_insert()
	
elseif idw_1 = idw_art_bonific then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_art_bonific.event ue_insert()

elseif idw_1 = idw_und_adicionales then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [1]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_und_adicionales.event ue_insert()	
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
	
string ls_msg1, ls_msg2

of_asigna_dws()

idw_master.AcceptText()
idw_datos_tecnicos.AcceptText()
idw_indicadores.AcceptText()
idw_saldos.AcceptText()

idw_saldos_almacen.AcceptText()
idw_equivalencias.AcceptText()
idw_precios_pactados.AcceptText()
idw_ubicacion.AcceptText()
idw_centro_benef.AcceptText()

		
idw_art_composicion.AcceptText()
idw_art_bonific.AcceptText()
idw_und_adicionales.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

if is_action = 'new' then
	if MessageBox('Aviso', 'Antes de grabar este ARTICULO nuevo, debe asegurarse que ' &
				   + 'la CATEGORÍA Y SUBCATEGORÍA son correctas; ' &
					+ 'es responsabilidad absoluta del usuario que las categoría ' &
					+ 'y subcategoría elegida corresponden al articulo. ' &
					+ '~r~n¿Desea continuar con la grabación del artículo?', &
					Information!, YesNo!, 2) = 2 then return
end if

if ib_log then
	idw_master.of_create_log()
	idw_equivalencias.of_create_log()
	idw_precios_pactados.of_create_log()
	idw_ubicacion.of_create_log()
	idw_saldos_almacen.of_create_log()
	idw_centro_benef.of_create_log()
	
	idw_art_composicion.of_create_log()
	idw_art_bonific.of_create_log()
	idw_und_adicionales.of_create_log()
end if

//Graba el dw_master
IF idw_master.ii_update = 1 or idw_indicadores.ii_update = 1 or &
	idw_datos_tecnicos.ii_update = 1 or idw_saldos.ii_update = 1  THEN
	
	IF idw_master.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
	
END IF

//Graba el dw_equiv 
IF idw_equivalencias.ii_update = 1 THEN	
	IF idw_equivalencias.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion equivalencias"
		ls_msg2 = "Se ha procedido al rollback"
	END IF
END IF

//Graba el dw_precio_p
IF idw_precios_pactados.ii_update = 1 THEN	
	IF idw_precios_pactados.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion equivalencias"
		ls_msg2 = "Se ha procedido al rollback, idw_pre_p"
	END IF
END IF

//Graba el dw_ubi
IF idw_ubicacion.ii_update = 1 THEN	
	IF idw_ubicacion.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Ubicaciones"
		ls_msg2 = "Se ha procedido al rollback, dw_ubi"
	END IF
END IF

//Graba el dw_saldos_almacen
IF idw_saldos_almacen.ii_update = 1 THEN	
	IF idw_saldos_almacen.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion SALDOS X ALMACEN"
		ls_msg2 = "Se ha procedido al rollback, dw_ubi"
	END IF
END IF

//Graba el dw_centro_benef
IF idw_centro_benef.ii_update = 1 THEN	
	IF idw_centro_benef.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion CENTRO DE BENEFICIO"
		ls_msg2 = "Se ha procedido al rollback, idw_centro_benef"
	END IF
END IF

IF idw_art_composicion.ii_update = 1 THEN	
	IF idw_art_composicion.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion ARTICULOS COMPOSICION"
		ls_msg2 = "Se ha procedido al rollback, idw_art_composicion"
	END IF
END IF

IF idw_art_bonific.ii_update = 1 THEN	
	IF idw_art_bonific.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion ARTICULOS BONIFICACION"
		ls_msg2 = "Se ha procedido al rollback, idw_art_bonific"
	END IF
END IF

IF idw_und_adicionales.ii_update = 1 THEN	
	IF idw_und_adicionales.Update(true, false) = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion UNIDADES ADICIONALES"
		ls_msg2 = "Se ha procedido al rollback, idw_und_adicionales"
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = idw_master.of_save_log()
		lbo_ok = idw_equivalencias.of_save_log()
		lbo_ok = idw_precios_pactados.of_save_log()
		lbo_ok = idw_ubicacion.of_save_log()
		lbo_ok = idw_saldos_almacen.of_save_log()
		lbo_ok = idw_centro_benef.of_save_log()
		
		lbo_ok = idw_art_composicion.of_save_log()
		lbo_ok = idw_art_bonific.of_save_log()
		lbo_ok = idw_und_adicionales.of_save_log()
		
	end if
END IF

IF lbo_ok THEN
	
	if is_action <> 'del' then
		if not of_articulo_venta() then return 
	end if
	
	COMMIT using SQLCA;
	
	idw_master.ResetUpdate()
	idw_indicadores.ResetUpdate()
	idw_datos_tecnicos.ResetUpdate()
	idw_saldos.ResetUpdate()
	idw_saldos_almacen.ResetUpdate()
	idw_equivalencias.ResetUpdate()
	idw_precios_pactados.ResetUpdate()
	idw_ubicacion.ResetUpdate()
	idw_centro_benef.ResetUpdate()
	idw_art_composicion.ResetUpdate()
	idw_art_bonific.ResetUpdate()
	idw_und_adicionales.ResetUpdate()
	
	idw_master.ii_update = 0
	idw_indicadores.ii_update = 0
	idw_datos_tecnicos.ii_update = 0
	idw_saldos.ii_update = 0
	idw_centro_benef.ii_update = 0
	idw_saldos_almacen.ii_update = 0
	idw_equivalencias.ii_update = 0
	idw_precios_pactados.ii_update = 0
	idw_ubicacion.ii_update = 0
	idw_centro_benef.ii_update = 0
	idw_art_composicion.ii_update = 0
	idw_art_bonific.ii_update = 0
	idw_und_adicionales.ii_update = 0
	
	is_action = 'open'
	
	if idw_master.GetRow() > 0 then
		of_retrieve(idw_master.object.cod_art[idw_master.GetRow()])
	end if
	
	f_mensaje("Cambios grabados satisfactoriamente.", "")
	
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2,exclamation!)
END IF
end event

event ue_dw_share;call super::ue_dw_share;// Compartir el dw_master con dws secundarios

Integer li_share_status
li_share_status = idw_master.ShareData (idw_indicadores)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con INDICADORES",exclamation!)
	RETURN
END IF
li_share_status = idw_master.ShareData (idw_saldos)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con SALDOS",exclamation!)
	RETURN
END IF
li_share_status = idw_master.ShareData (idw_datos_tecnicos)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DATOS TECNICOS",exclamation!)
	RETURN
END IF
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

if idw_1 = idw_ubicacion and idw_ubicacion.ii_protect = 0 then
	of_set_modify()
end if

if idw_1 = idw_indicadores and idw_indicadores.ii_protect = 0 then
	//Aplicar los cambios en los campos de acuerdo a los flags
	this.of_set_cambios( )
end if

is_Action = 'edit'


end event

event ue_update_pre;call super::ue_update_pre;decimal 	ldc_prec_ult_comp
String 	ls_cod_art, ls_sub_cat
Long		ll_count
// Verifica que campos son requeridos y tengan valores
ib_update_check = false

idw_master.AcceptText()
idw_saldos.AcceptText()
idw_indicadores.AcceptText()
idw_datos_Tecnicos.AcceptText()
idw_precios_pactados.Accepttext( )
idw_equivalencias.accepttext( )
idw_saldos_almacen.AcceptText()
idw_ubicacion.AcceptText()
idw_art_composicion.AcceptText()
idw_art_bonific.AcceptText()
idw_und_adicionales.AcceptText()

if idw_master.GetRow() = 0 and is_action <> 'del' then return

if gnvo_app.of_row_Processing( idw_master) <> true then	
	tab_1.Selectedtab = 1
	return
end if

if gnvo_app.of_row_Processing( idw_equivalencias) <> true then 
	tab_1.Selectedtab = 3
	return
end if

if gnvo_app.of_row_Processing( idw_precios_pactados) <> true then	
	tab_1.Selectedtab = 7
	return
end if

if gnvo_app.of_row_Processing( idw_saldos) <> true then 
	tab_1.Selectedtab = 4
	return
end if

if gnvo_app.of_row_Processing( idw_art_composicion) <> true then 
	tab_1.Selectedtab = 10
	return
end if

if gnvo_app.of_row_Processing( idw_art_bonific) <> true then 
	tab_1.Selectedtab = 11
	return
end if

if gnvo_app.of_row_Processing( idw_und_adicionales) <> true then 
	tab_1.Selectedtab = 12
	return
end if

if idw_saldos.GetRow() = 0 and is_Action <> 'del' then 
	MessageBox('Error', 'No hay registro en la solapa SALDOS', StopSign!)
	return
end if

if is_action = 'new' then
	//Verifico que no se duplique el codigo de articulo
	ls_cod_art = idw_master.object.cod_art		[idw_master.GetRow()]
	ls_sub_Cat = idw_master.object.sub_cat_art[idw_master.GetRow()]
	
	select count(*)
	  into :ll_count
	  from articulo
	  where cod_Art = :ls_cod_art;
	
	if ll_count > 0 then
		ls_cod_art = gnvo_app.logistica.of_next_cod_art(ls_sub_cat)
		idw_master.object.cod_art[idw_master.GetRow()] = ls_cod_art
		idw_master.ii_update = 1
	end if
end if

ib_update_check = True

idw_master.of_set_flag_replicacion()
idw_indicadores.of_set_flag_replicacion()
idw_datos_tecnicos.of_set_flag_replicacion()
idw_saldos.of_set_flag_replicacion()
idw_ubicacion.of_set_flag_replicacion()
idw_saldos_almacen.of_set_flag_replicacion()
idw_equivalencias.of_set_flag_replicacion()
idw_precios_pactados.of_set_flag_replicacion()
idw_art_composicion.of_set_flag_replicacion()
idw_art_bonific.of_set_flag_replicacion()
idw_und_adicionales.of_set_flag_replicacion()
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_master.ii_update					= 1 OR &
	idw_indicadores.ii_update 			= 1 OR &
	idw_saldos.ii_update 				= 1 OR &
	idw_datos_tecnicos.ii_update 		= 1 OR &
	idw_saldos_almacen.ii_update 		= 1 OR &
	idw_equivalencias.ii_update 		= 1 OR &
	idw_precios_pactados.ii_update 	= 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_master.ii_update					= 0
		idw_indicadores.ii_update 			= 0
		idw_saldos.ii_update 				= 0
		idw_datos_tecnicos.ii_update 		= 0
		idw_saldos_almacen.ii_update 		= 0
		idw_equivalencias.ii_update 		= 0
		idw_precios_pactados.ii_update 	= 0
	END IF
END IF

end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

//idw_master.width = tab_1.tabpage_1.width - idw_master.X - 10
idw_master.height = tab_1.tabpage_1.height - idw_master.y - 10

idw_indicadores.width 		= tab_1.tabpage_2.width - idw_indicadores.X - 10
idw_indicadores.height 		= tab_1.tabpage_2.height - idw_indicadores.y - 10

idw_saldos.width 				= tab_1.tabpage_3.width - idw_saldos.X - 10
idw_saldos.height 			= tab_1.tabpage_3.height - idw_saldos.y - 10

idw_datos_tecnicos.width 	= tab_1.tabpage_8.width - idw_datos_tecnicos.X - 10
idw_datos_tecnicos.height 	= tab_1.tabpage_8.height - idw_datos_tecnicos.y - 10

idw_ubicacion.width 			= tab_1.tabpage_4.width - idw_ubicacion.X - 10
idw_ubicacion.height 		= tab_1.tabpage_4.height - idw_ubicacion.y - 10

idw_saldos_almacen.width 	= tab_1.tabpage_5.width - idw_saldos_almacen.X - 10
idw_saldos_almacen.height 	= tab_1.tabpage_5.height - idw_saldos_almacen.y - 10

idw_equivalencias.width 	= tab_1.tabpage_6.width - idw_equivalencias.X - 10
idw_equivalencias.height	= tab_1.tabpage_6.height - idw_equivalencias.y - 110

idw_precios_pactados.width = tab_1.tabpage_7.width - idw_precios_pactados.X - 10
idw_precios_pactados.height= tab_1.tabpage_7.height - idw_precios_pactados.y - 10

idw_centro_benef.width 		= tab_1.tabpage_9.width - idw_centro_benef.X - 10
idw_centro_benef.height 	= tab_1.tabpage_9.height - idw_centro_benef.y - 10

idw_art_composicion.width 	= tab_1.tabpage_10.width - idw_art_composicion.X - 10
idw_art_composicion.height = tab_1.tabpage_10.height - idw_art_composicion.y - 10

idw_art_bonific.width 		= tab_1.tabpage_11.width - idw_art_bonific.X - 10
idw_art_bonific.height 		= tab_1.tabpage_11.height - idw_art_bonific.y - 10

idw_und_adicionales.width 	= tab_1.tabpage_12.width - idw_und_adicionales.X - 10
idw_und_adicionales.height = tab_1.tabpage_12.height - idw_und_adicionales.y - 10

st_1.width = tab_1.width 
end event

event open;//Ancestor Script Override

if of_get_param() = 0 then 
	post event close()   
	return
end if

of_asigna_dws()

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_delete;// Ancestor Script has been Override
Long  ll_row

if Not(idw_1 = idw_master or idw_1 = idw_centro_benef  or idw_1 = idw_equivalencias or &
	    idw_1 = idw_precios_pactados or idw_1 = idw_art_composicion or &
		 idw_1 = idw_art_bonific or idw_1 = idw_und_adicionales) then 
	
	MessageBox('Error', 'No esta permitida esta opción por favor verifique!', StopSign!)
	return
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
is_Action = 'del'
end event

event close;call super::close;destroy invo_wait
end event

event ue_retrieve_list;Long ll_row
String ls_codsub

this.event dynamic ue_update_request()

// Abre ventana de ayuda 
Str_articulo lstr_articulo

lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )

if lstr_articulo.b_Return then
	this.of_retrieve(lstr_articulo.cod_art)
	is_action = 'open'
end if

end event

type tab_1 from tab within w_cm010_articulos
integer y = 124
integer width = 4206
integer height = 1816
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_12 tabpage_12
tabpage_8 tabpage_8
tabpage_6 tabpage_6
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
tabpage_9 tabpage_9
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_12=create tabpage_12
this.tabpage_8=create tabpage_8
this.tabpage_6=create tabpage_6
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_7=create tabpage_7
this.tabpage_9=create tabpage_9
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_12,&
this.tabpage_8,&
this.tabpage_6,&
this.tabpage_10,&
this.tabpage_11,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_7,&
this.tabpage_9}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_12)
destroy(this.tabpage_8)
destroy(this.tabpage_6)
destroy(this.tabpage_10)
destroy(this.tabpage_11)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_7)
destroy(this.tabpage_9)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Datos Generales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
string powertiptext = "Datos Generales del Articulo"
cb_upload cb_upload
dw_master dw_master
p_foto p_foto
pb_resize pb_resize
end type

on tabpage_1.create
this.cb_upload=create cb_upload
this.dw_master=create dw_master
this.p_foto=create p_foto
this.pb_resize=create pb_resize
this.Control[]={this.cb_upload,&
this.dw_master,&
this.p_foto,&
this.pb_resize}
end on

on tabpage_1.destroy
destroy(this.cb_upload)
destroy(this.dw_master)
destroy(this.p_foto)
destroy(this.pb_resize)
end on

type cb_upload from commandbutton within tabpage_1
integer x = 3008
integer y = 704
integer width = 1152
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Subir Foto"
end type

event clicked;Integer 	li_result
String	ls_docname, ls_named, ls_path, ls_cod_art

try 
	if idw_master.GetRow() = 0 then 
		MessageBox('Error', "No ha cargado ningun articulo, tiene cargar primero un registro para subir su foto. Por favor verifique!", StopSign!)
		return
	end if
	
	ls_path = gnvo_app.of_get_parametro('RUTA_FOTOS_UPLOAD', GetCurrentDirectory ( ))
	
	li_result = GetFileOpenName("Seleccione Fotografía", &
					ls_docname, ls_named, "JPG", &
					"Archivos JPG (*.JPG),*.JPG, Archivos PNG (*.PNG),*.PNG", &
					ls_path)
	
	if li_result = 1 then
			
		ls_cod_art = idw_master.object.cod_art[dw_master.getRow()]
		
		if ls_cod_art = "" or IsNull(ls_cod_art) then
			MessageBox('Error', 'El codigo de ARTICULO esta en blanco, '&
									+ 'asegurese de grabar los datos antes de asignar la foto')
			return
		end if
		
		//SetMicroHelp("Un momento cargando la foto del artículo....")
		yield()
		invo_wait.of_mensaje("Cargando la imagen en memoria....")
		yield()


		ibl_imagen = invo_util.of_load_blob(ls_docname)
		
		if not ISNull(ibl_imagen) then
			yield()
			invo_wait.of_mensaje("Actualizando imagen en la tabla ARTICULO....")
			yield()

			if gnvo_app.logistica.of_save_blob(ls_cod_art, ibl_imagen) then
			
				ip_foto.SetRedraw(FALSE)
				ip_foto.SetPicture(ibl_imagen)
				ip_foto.SetRedraw(TRUE)
				
				ipb_resize.visible = true
			end if 
		else

			ip_foto.SetRedraw(FALSE)
			ip_foto.PictureName = gs_logo
			ip_foto.SetRedraw(TRUE)
			
			ipb_resize.visible = false

		end if
		
		
	end if
	
catch ( Exception ex)
	
	gnvo_app.of_catch_exception(ex, 'Error al momento de subir la foto')

finally
	invo_wait.of_close()
end try


end event

type dw_master from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 2981
integer height = 1660
boolean bringtotop = true
string dataobject = "d_abc_articulo_generales_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art, ls_desc_art

try 
	choose case lower(as_columna)
			
		case "cat_art"
			ls_sql = "SELECT cat_art AS CODIGO_categoria, " &
					  + "DESC_categoria AS DESCRIPCION_categoria " &
					  + "FROM articulo_categ " &
					  + "where flag_servicio = '0'" &
					  + "  and flag_estado 	 <>'0'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, &
						ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.cat_art			[al_row] = ls_codigo
				this.object.desc_categoria	[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "sub_cat_art"
			ls_cat_art = this.object.cat_art[al_row]
			if ls_cat_art = '' or IsNull(ls_cat_art) then
				MessageBox('Aviso', 'Debe definir primero la categoria del articulo')
				return
			end if
			
			ls_sql = "SELECT COD_SUB_CAT AS CODIGO_sub_categoria, " &
					  + "DESC_SUB_CAT AS DESCRIPCION_sub_categoria, " &
					  + "peso_seco AS peso_seco, " &
					  + "peso_bruto AS peso_bruto, " &
					  + "version AS version " &
					  + "FROM articulo_sub_categ " &
					  + "where flag_servicio = '0'" &
					  + "  and flag_estado 	<> '0'" &
					  + "and cat_Art = '" + ls_cat_art + "'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, &
						ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.sub_cat_art		[al_row] = ls_codigo
				this.object.desc_sub_cat	[al_row] = ls_data
				
				
				if is_action = 'new' then
					this.object.cod_art[al_row] = gnvo_app.logistica.of_next_cod_art( ls_codigo )
				end if
				
				if gnvo_app.of_get_parametro("COMPRAS_COPIAR_TXT_SUBCATEG", "1") = "1" then
					ls_desc_art = this.object.desc_art [al_row]				
					
					if ISNull(ls_desc_art) or trim(ls_desc_art) = '' then
						if MessageBox("Aviso", "¿Desea copiar el texto de la subcategoría en el texto del articulo?", Information!, YesNo!, 2) = 1 then
							this.object.desc_art 		[al_row] = ls_data
							this.object.nom_Articulo 	[al_row] = mid(ls_data,1,150)
						end if
					end if
				end if
				
				//Duplicar el código SKU
				if gnvo_app.of_get_parametro("COMPRAS_SKU_IGUAL_COD_ART", "1") = "1" then
					if MessageBox("Aviso", "¿Desea copiar el código del artículo como código SKU?", Information!, YesNo!, 2) = 1 then
						this.object.cod_sku 		[al_row] = this.object.cod_art [al_row]
					end if
				end if


				this.ii_update = 1
				
			end if
			
			return
			
		case "und"
			ls_sql = "SELECT und AS codigo_unidad, " &
					 + "DESC_unidad AS DESCRIPCION_unidad " &
					 + "FROM unidad " 
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.und			[al_row] = ls_codigo
				this.object.desc_unidad	[al_row] = ls_data
				this.ii_update = 1
			end if
			return
		
		case "cod_clase"
			ls_sql = "SELECT cod_clase AS codigo_clase, " &
					 + "DESC_clase AS DESCRIPCION_clase " &
					 + "FROM articulo_clase " 
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_clase	[al_row] = ls_codigo
				this.object.desc_clase	[al_row] = ls_data
				this.ii_update = 1
			end if
			return
			
		case "cod_marca"
			ls_sql = "SELECT cod_marca AS codigo_marca, " &
					 + "nom_marca AS descripcion_marca " &
					 + "FROM marca " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_marca	[al_row] = ls_codigo
				this.object.nom_marca	[al_row] = ls_data
				this.ii_update = 1
			end if
			return
		
		case "cod_talla"
			ls_sql = "select at.cod_talla as codigo_talla, " &
					 + "       at.desc_talla as descripcion_talla " &
					 + "from articulo_talla at " &
					 + "where at.flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_talla	[al_row] = ls_codigo
				this.object.desc_talla	[al_row] = ls_data
				this.ii_update = 1
			end if
			return

		case "color1"
			ls_sql = "select c.color as color, " &
					 + "c.descripcion as desc_Color " &
					 + "  from color c " &
					 + "where c.flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.color1		[al_row] = ls_codigo
				this.object.desc_color1	[al_row] = ls_data
				this.ii_update = 1
			end if
			return		

		case "color2"
			ls_sql = "select c.color as color, " &
					 + "c.descripcion as desc_Color " &
					 + "  from color c " &
					 + "where c.flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.color2		[al_row] = ls_codigo
				this.object.desc_color2	[al_row] = ls_data
				this.ii_update = 1
			end if
			return				
			
		case "cod_cubso"
			ls_sql = "select cod_cubso as codigo_cubso, " &
					 + "desc_bien_serv_obra as descripcion_bien_Servicio_obra " &
					 + "from sunat_cubso " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_cubso				[al_row] = ls_codigo
				this.object.desc_bien_serv_obra	[al_row] = ls_data
				this.ii_update = 1
			end if
			return
	
	end choose
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
end try

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda
String 	ls_name, ls_prot, ls_cod_art, ls_docname, ls_named, ls_desc
Integer 	li_ano, li_value
str_parametros sl_param

this.AcceptText()
ls_name = dwo.name
ls_prot = dw_master.Describe(  "cod_art.Protect" )

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name 
	CASE 'b_imagen'
		li_value = GetFileOpenName("Seleccione Archivo", ls_docname, ls_named, "BMP", &
			+ "Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG, " &
			+ "Archivos BMP (*.GIF),*.GIF")
		IF li_value = 1 THEN 
			this.object.file_imagen[row] = ls_docname
			this.ii_update = 1
		END IF
		
	CASE "b_descripcion"
		// Para la descripcion de la Factura
		ls_desc 		= This.object.desc_art 	[row]
		
		sl_param.string1   = 'Descripción del artículo'
		sl_param.string2	 = ls_desc
	
		OpenWithParm( w_descripcion_fac, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			This.object.desc_art 		[row] = sl_param.string3
			this.object.nom_articulo	[row] = left(sl_param.string3, 40)
			this.ii_update = 1
		END IF
		
END CHOOSE

end event

event itemchanged;call super::itemchanged;string 	ls_desc, ls_cat, ls_cod_art, ls_desc_art
Long		ll_count

try 
	if dwo.name = 'cat_art' then
		
		Select desc_categoria 
			into :ls_desc 
		from articulo_categ
		where cat_art = :data;	
		
		if SQLCA.SQLCode = 100 then
			messagebox( "Error", "Categoria no existe", exclamation!)
			this.object.cat_art			[row] = gnvo_app.is_null
			this.object.desc_categoria	[row] = gnvo_app.is_null
			return 1
		end if
	
		
		this.object.desc_categoria[row] = ls_desc
		
	elseif dwo.name = 'sub_cat_art' then
		ls_cat = this.object.cat_art[row]
		
		Select desc_sub_cat 
			into :ls_desc 
		from articulo_sub_categ
		where cat_art = :ls_cat 
		  and cod_sub_cat = :data;
	
		if SQLCA.SQLCode = 100 then
			messagebox( "Error", "Sub Categoria no esta definida", exclamation!)
			this.object.sub_cat_art[row] = gnvo_app.is_null
			this.object.sub_cat_art[row] = gnvo_app.is_null
			return 1
		end if
	
		this.object.desc_sub_cat[row] = ls_desc	
		
		if is_action = 'new' then
			this.object.cod_art[row] = gnvo_app.logistica.of_next_cod_art( data )
		end if
		
		if gnvo_app.of_get_parametro("COMPRAS_COPIAR_TXT_SUBCATEG", "1") = "1" then
			ls_desc_art = this.object.desc_art [row]				
			
			if ISNull(ls_desc_art) or trim(ls_desc_art) = '' then
				if MessageBox("Aviso", "¿Desea copiar el texto de la subcategoría en el texto del articulo?", Information!, YesNo!, 2) = 1 then
					this.object.desc_art 		[row] = ls_desc
					this.object.nom_Articulo 	[row] = mid(ls_desc,1,150)
				end if
			end if
		end if
		
		//Duplicar el código SKU
		if gnvo_app.of_get_parametro("COMPRAS_SKU_IGUAL_COD_ART", "1") = "1" then
			if MessageBox("Aviso", "¿Desea copiar el código del artículo como código SKU?", Information!, YesNo!, 2) = 1 then
				this.object.cod_sku 		[row] = this.object.cod_art [row]
			end if
		end if
	
		
	elseif dwo.name = 'cod_art' then
		// verifica si ya existe
		
		Select count( cod_art) 
			into :ll_count 
		from articulo
		where cod_art = :data;	
		
		if ll_count = 1 then
			messagebox( "Error", "Codigo de articulo " + data + " ya esta definido, por favor verifique!", exclamation!)
			this.object.cod_art[row] = gnvo_app.is_null
			return 1
		end if	
		
		//Duplicar el código SKU
		if gnvo_app.of_get_parametro("COMPRAS_SKU_IGUAL_COD_ART", "1") = "1" then
			if MessageBox("Aviso", "¿Desea copiar el código del artículo como código SKU?", Information!, YesNo!, 2) = 1 then
				this.object.cod_sku 		[row] = this.object.cod_art [row]
			end if
		end if

		
	elseif dwo.name = 'desc_art' then
		
		this.object.nom_articulo [row] = mid(data, 1, 40)
		
	elseif dwo.name = 'und' then
		
		select desc_unidad
			into :ls_desc
		from unidad
		where und = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de unidad o no se encuentra activo, por favor verifique!', StopSign!)
			this.object.und 			[row] = gnvo_app.is_null
			this.object.desc_unidad [row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_unidad [row] = ls_desc
		
	elseif dwo.name = 'cod_clase' then
		
		select desc_clase
			into :ls_desc
		from articulo_clase
		where cod_clase = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de clase o no está activo, por favor verifique!', Exclamation!)
			this.object.cod_clase 	[row] = gnvo_app.is_null
			this.object.desc_clase 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_clase 		[row] = ls_desc
		
	elseif dwo.name = 'cod_cubso' then
		
		select desc_bien_serv_obra
			into :ls_desc
		from sunat_cubso
		where cod_cubso = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe CÓDIGO UNICO DE BIEN, SERVICIO U OBRA DEL ESTADO, o no se encuentra activo, por favor verifique', Exclamation!)
			this.object.cod_cubso 				[row] = gnvo_app.is_null
			this.object.desc_bien_serv_obra 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_bien_serv_obra 		[row] = ls_desc
	
	elseif dwo.name = 'cod_marca' then
		
		select nom_marca
			into :ls_desc
		from marca
		where cod_marca = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de Marca no no se encuentra activo, por favor verifique', Exclamation!)
			this.object.cod_marca 	[row] = gnvo_app.is_null
			this.object.nom_marca 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.nom_marca 		[row] = ls_desc
	
	elseif dwo.name = 'cod_sku' then
		
		ls_cod_Art = this.object.cod_art [row]
		
		if gnvo_app.of_get_parametro("VALIDAR_COD_SKU_DUPLICADO", "1") = "1" or gs_empresa <> 'SERVIMOTOR' then
		
			select count(*)
				into :ll_count
			from articulo
			where cod_sku 		= :data
			  and cod_Art		<> :ls_cod_art
			  and flag_estado = '1';
			
			if ll_count > 0 then
				MessageBox('Aviso', 'El Código SKU ' + data + ' ya existe en el maestro de artículos, por favor verifique', Exclamation!)
				this.object.cod_sku 	[row] = gnvo_app.is_null
				return 1
			end if
		end if
		
		this.object.nom_marca 		[row] = ls_desc

	end if
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
end try


end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen			[al_row] = gs_origen
this.object.flag_estado			[al_row] = '1'
this.object.costo_prom_sol 	[al_row] = 0
this.object.costo_prom_dol 	[al_row] = 0
this.object.peso_und 			[al_row] = 0.00
this.object.moneda_compra		[al_row] = gnvo_app.is_dolares
this.object.costo_ult_compra 	[al_row] = 0.01
this.object.fec_registro		[al_row] = gnvo_app.of_fecha_Actual()
this.object.cod_usr				[al_row] = gs_user


this.object.flag_estado				[al_row] = '1'
this.object.flag_inventariable	[al_row] = '1'
this.object.flag_reposicion		[al_row] = '0'
this.object.flag_critico			[al_row] = '0'
this.object.flag_obsoleto			[al_row] = '0'
this.object.flag_und2				[al_row] = '0'
this.object.flag_cntrl_lote		[al_row] = '0'
this.object.dias_reposicion		[al_row] = 7
this.object.dias_rep_import		[al_row] = 0
this.object.flag_iqpf				[al_row] = '0'
this.object.flag_replicacion		[al_row] = '1'
this.object.flag_cntrl_lote		[al_row] = '0'


this.object.color1					[al_row] = '000'
this.object.color2					[al_row] = '000'

idw_saldos.of_protect()
is_action = 'new'

this.SetColumn('cat_art')
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type p_foto from picture within tabpage_1
event ue_maximized ( )
event ue_restored ( )
integer x = 3003
integer width = 1166
integer height = 688
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event ue_maximized();//Long ll_height, ll_width, ll_new_height
//
//
//ll_new_height = p_foto.y + p_foto.height
//
//p_foto.y = st_4.y
//p_foto.height = ll_new_height - p_foto.y
//
//p_foto.width = dw_master.x + dw_master.width - p_foto.x
//
////Boton resize
//pb_resize.x = p_foto.x + p_foto.width - pb_resize.width - 10
//pb_resize.y = p_foto.y + 10
//
////Cambio de imagen
//pb_resize.PictureName = "C:\SIGRE\resources\PNG\restored.png"
//
////Aplico la imagen
//of_imagen_file(lb_files.SelectedIndex())
//
////Indico que ya esta maximizado
//lb_maximized = true
end event

event ue_restored();//Long ll_height
//
//ll_height = p_foto.y + p_foto.height
//
//p_foto.y = lb_files.y + lb_files.height + 10
//p_foto.height = ll_height - p_foto.y 
//
//p_foto.width = lb_files.width
//
////Boton resize
//pb_resize.x = p_foto.x + p_foto.width - pb_resize.width - 10
//pb_resize.y = p_foto.y + 10
//
////Cambio de imagen
//pb_resize.PictureName = "C:\SIGRE\resources\PNG\maximizar.png"
//
////Aplico la imagen
//of_imagen_file(lb_files.SelectedIndex())
//
////Indico que ya esta maximizado
//lb_maximized = false
end event

type pb_resize from picturebutton within tabpage_1
integer x = 4023
integer y = 12
integer width = 133
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\maximizar.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Maximizar la imagen"
end type

event clicked;//if not lb_maximized then
//	//p_foto.event ue_maximized()
//else
//	//p_foto.event ue_restored()
//end if

if not IsNull(ibl_imagen) then
	gnvo_app.logistica.of_show_imagen(ibl_imagen)
end if
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Indicadores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CheckBox!"
long picturemaskcolor = 536870912
dw_indicadores dw_indicadores
end type

on tabpage_2.create
this.dw_indicadores=create dw_indicadores
this.Control[]={this.dw_indicadores}
end on

on tabpage_2.destroy
destroy(this.dw_indicadores)
end on

type dw_indicadores from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer width = 3104
integer height = 1272
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_indicadores_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art

choose case lower(as_columna)
	case "cod_talla"
		ls_sql = "select t.cod_talla as codigo_talla, " &
				 + "t.desc_talla as descripcion_talla " &
				 + "  from articulo_talla t " &
				 + "where t.flag_estado = '1'" 
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_talla			[al_row] = ls_codigo
			this.object.desc_talla			[al_row] = ls_data
			this.ii_update = 1
		end if

		
	case "und2"
		ls_sql = "SELECT und AS CODIGO_und, " &
				  + "DESC_unidad AS DESCRIPCION_unidad " &
				  + "FROM unidad " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.und2			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		return
	
	case "cnta_prsp"
		ls_sql = "SELECT cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "DESCripcion AS DESCRIPCION_cnta_prsp " &
				  + "FROM presupuesto_cuenta " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		return
	
end choose
end event

event constructor;call super::constructor;ii_ck[1] = 1		
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado				[al_row] = '1'
this.object.flag_inventariable	[al_row] = '1'
this.object.flag_reposicion		[al_row] = '0'
this.object.flag_critico			[al_row] = '0'
this.object.flag_obsoleto			[al_row] = '0'
this.object.flag_und2				[al_row] = '0'
this.object.flag_cntrl_lote		[al_row] = '0'
this.object.dias_reposicion		[al_row] = 7
this.object.dias_rep_import		[al_row] = 0
end event

event itemchanged;call super::itemchanged;long 		ll_count
decimal	ldc_sldo_min, ldc_sldo_max
String	ls_desc

this.AcceptText( )

if dwo.name = 'flag_reposicion' then
	if data = '0' then
		this.Object.sldo_minimo.Protect = 1
		this.Object.sldo_maximo.Protect = 1
		this.Object.cnt_compra_rec.Protect = 1
		this.object.sldo_minimo.EditMask.required = 'Yes'
		this.object.sldo_maximo.EditMask.required = 'Yes'
		this.object.cnt_compra_rec.EditMask.required = 'Yes'
	else
		this.Object.sldo_minimo.Protect = 0
		this.Object.sldo_maximo.Protect = 0
		this.Object.cnt_compra_rec.Protect = 0
		this.object.sldo_minimo.EditMask.required = 'No'
		this.object.sldo_maximo.EditMask.required = 'No'
		this.object.cnt_compra_rec.EditMask.required = 'No'
	end if
	return

elseif dwo.name = 'flag_critico' then
	
	// Si tiene activo el fla reposicion, entonces 
	// no es necesario activar los campos, porque ya los 
	// tiene activo
	if this.object.flag_reposicion[row] = '1' then return
	
	if data = '0' then
		this.Object.sldo_minimo.Protect = 1
		this.Object.cnt_compra_rec.Protect = 1
		this.object.sldo_minimo.EditMask.required = 'Yes'
		this.object.cnt_compra_rec.EditMask.required = 'Yes'
	else
		this.Object.sldo_minimo.Protect = 0
		this.Object.cnt_compra_rec.Protect = 0
		this.object.sldo_minimo.EditMask.required = 'No'
		this.object.cnt_compra_rec.EditMask.required = 'No'
	end if
	return
	
elseif dwo.name = 'flag_und2' then
	
	if data = '0' then
		this.Object.und2.Protect = 1
		this.Object.factor_conv_und.Protect = 1
		this.object.und2.edit.required = 'Yes'
		this.object.factor_conv_und.EditMask.required = 'Yes'
	else
		this.Object.und2.Protect = 0
		this.Object.factor_conv_und.Protect = 0
		this.object.und2.edit.required = 'No'
		this.object.factor_conv_und.EditMask.required = 'No'
	end if
	return
elseif dwo.name = 'flag_cntrl_presup' then
	
	if data = '0' then
		this.Object.cnta_prsp.Protect = 1
		this.object.cnta_prsp.edit.required = 'Yes'
	else
		this.Object.cnta_prsp.Protect = 0
		this.object.cnta_prsp.edit.required = 'No'
	end if
	return
elseif dwo.name = 'und2' then
	
	select count(*)
		into :ll_count
	from unidad
	where und = :data;
	
	if ll_count = 0 then
		MessageBox('Aviso', 'No existe codigo de unidad')
		return 1
	end if
	
	return
	
elseif dwo.name = 'cod_talla' then
	
	select desc_talla
		into :ls_desc
	from articulo_talla
	where cod_talla = :data
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Código de talla ' + data + ' no existe o no se encuentra activo', StopSign!)
		return 1
	end if
	
	this.object.desc_talla [row] = ls_desc
	return	
	
elseif dwo.name = 'cnta_prsp' then
	
	select count(*)
		into :ll_count
	from presupuesto_cuenta
	where cnta_prsp = :data;
	
	if ll_count = 0 then
		MessageBox('Aviso', 'No existe codigo de Cuenta Presupuestal')
		return 1
	end if
	
	return
	
elseif dwo.name = 'sldo_maximo' then
	ldc_sldo_min = dec(this.object.sldo_minimo[row])
	ldc_sldo_max = dec(this.object.sldo_maximo[row])
	
	if IsNull(ldc_sldo_max) then ldc_sldo_max = 0
	if IsNull(ldc_sldo_min) then ldc_sldo_min = 0
	
	if ldc_sldo_max <= ldc_sldo_min then
		MessageBox('Aviso', 'El saldo maximo debe ser mayor que el saldo minimo')
		return
	end if
	
	this.object.cnt_compra_rec[row] = ldc_sldo_max - ldc_sldo_min
end if

idw_master.ii_update =1

end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_12 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Unidades~r~nAdicionales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "DatabaseProfile!"
long picturemaskcolor = 536870912
dw_und_adicionales dw_und_adicionales
end type

on tabpage_12.create
this.dw_und_adicionales=create dw_und_adicionales
this.Control[]={this.dw_und_adicionales}
end on

on tabpage_12.destroy
destroy(this.dw_und_adicionales)
end on

type dw_und_adicionales from u_dw_abc within tabpage_12
integer width = 3173
integer height = 1200
string dataobject = "d_abc_unidades_adicionales_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_desc

This.AcceptText()

choose case lower(dwo.name)
	case 'und'
		select desc_unidad
			into :ls_desc
		from unidad
		where flag_estado = '1'
		  and und = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Unidad ' + data + ' no existe o no esta activo', StopSign!)
			this.object.und 				[row] = gnvo_app.is_null
			this.object.desc_unidad 	[row] = gnvo_app.is_null
		end if
		
		this.object.desc_unidad [row] = ls_desc

		
end choose



end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_cod_art

if idw_master.GetRow() = 0 then return

ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo', StopSign!)
	return
end if



this.object.cod_art				[al_row] = ls_cod_art
this.object.cod_usr 				[al_row] = gs_user
this.object.factor_conv_und 	[al_row] = 1.0000

end event

event ue_display;string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "und"
		ls_sql = "select u.und as codigo_und, " &
				 + "u.desc_unidad as desc_unidad " &
				 + "from unidad u " &
				 + "where u.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.und			[al_row] = ls_codigo
			this.object.desc_unidad	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		
end choose
end event

type tabpage_8 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Datos~r~nTecnicos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Structure5!"
long picturemaskcolor = 536870912
dw_datos_tecnicos dw_datos_tecnicos
end type

on tabpage_8.create
this.dw_datos_tecnicos=create dw_datos_tecnicos
this.Control[]={this.dw_datos_tecnicos}
end on

on tabpage_8.destroy
destroy(this.dw_datos_tecnicos)
end on

type dw_datos_tecnicos from u_dw_abc within tabpage_8
integer width = 3104
integer height = 1272
boolean bringtotop = true
string dataobject = "d_abc_articulo_otros_datos_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1		
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;long 		ll_count
decimal	ldc_sldo_min, ldc_sldo_max

this.AcceptText( )

if dwo.name = 'flag_reposicion' then
	if data = '0' then
		this.Object.sldo_minimo.Protect = 1
		this.Object.sldo_maximo.Protect = 1
		this.Object.cnt_compra_rec.Protect = 1
		this.object.sldo_minimo.EditMask.required = 'Yes'
		this.object.sldo_maximo.EditMask.required = 'Yes'
		this.object.cnt_compra_rec.EditMask.required = 'Yes'
	else
		this.Object.sldo_minimo.Protect = 0
		this.Object.sldo_maximo.Protect = 0
		this.Object.cnt_compra_rec.Protect = 0
		this.object.sldo_minimo.EditMask.required = 'No'
		this.object.sldo_maximo.EditMask.required = 'No'
		this.object.cnt_compra_rec.EditMask.required = 'No'
	end if
	return

elseif dwo.name = 'flag_critico' then
	
	// Si tiene activo el fla reposicion, entonces 
	// no es necesario activar los campos, porque ya los 
	// tiene activo
	if this.object.flag_reposicion[row] = '1' then return
	
	if data = '0' then
		this.Object.sldo_minimo.Protect = 1
		this.Object.cnt_compra_rec.Protect = 1
		this.object.sldo_minimo.EditMask.required = 'Yes'
		this.object.cnt_compra_rec.EditMask.required = 'Yes'
	else
		this.Object.sldo_minimo.Protect = 0
		this.Object.cnt_compra_rec.Protect = 0
		this.object.sldo_minimo.EditMask.required = 'No'
		this.object.cnt_compra_rec.EditMask.required = 'No'
	end if
	return
	
elseif dwo.name = 'flag_und2' then
	
	if data = '0' then
		this.Object.und2.Protect = 1
		this.Object.factor_conv_und.Protect = 1
		this.object.und2.edit.required = 'Yes'
		this.object.factor_conv_und.EditMask.required = 'Yes'
	else
		this.Object.und2.Protect = 0
		this.Object.factor_conv_und.Protect = 0
		this.object.und2.edit.required = 'No'
		this.object.factor_conv_und.EditMask.required = 'No'
	end if
	return
elseif dwo.name = 'flag_cntrl_presup' then
	
	if data = '0' then
		this.Object.cnta_prsp.Protect = 1
		this.object.cnta_prsp.edit.required = 'Yes'
	else
		this.Object.cnta_prsp.Protect = 0
		this.object.cnta_prsp.edit.required = 'No'
	end if
	return
elseif dwo.name = 'und2' then
	
	select count(*)
		into :ll_count
	from unidad
	where und = :data;
	
	if ll_count = 0 then
		MessageBox('Aviso', 'No existe codigo de unidad')
		return 1
	end if
	
	return
	
elseif dwo.name = 'cnta_prsp' then
	
	select count(*)
		into :ll_count
	from presupuesto_cuenta
	where cnta_prsp = :data;
	
	if ll_count = 0 then
		MessageBox('Aviso', 'No existe codigo de Cuenta Presupuestal')
		return 1
	end if
	
	return
	
elseif dwo.name = 'sldo_maximo' then
	ldc_sldo_min = dec(this.object.sldo_minimo[row])
	ldc_sldo_max = dec(this.object.sldo_maximo[row])
	
	if IsNull(ldc_sldo_max) then ldc_sldo_max = 0
	if IsNull(ldc_sldo_min) then ldc_sldo_min = 0
	
	if ldc_sldo_max <= ldc_sldo_min then
		MessageBox('Aviso', 'El saldo maximo debe ser mayor que el saldo minimo')
		return
	end if
	
	this.object.cnt_compra_rec[row] = ldc_sldo_max - ldc_sldo_min
end if

idw_master.ii_update =1

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado				[al_row] = '1'
this.object.flag_inventariable	[al_row] = '1'
this.object.flag_reposicion		[al_row] = '0'
this.object.flag_critico			[al_row] = '0'
this.object.flag_obsoleto			[al_row] = '0'
this.object.flag_und2				[al_row] = '0'
this.object.flag_cntrl_lote		[al_row] = '0'
this.object.dias_reposicion		[al_row] = 7
this.object.dias_rep_import		[al_row] = 0
end event

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art

choose case lower(as_columna)
		
	case "und2"
		ls_sql = "SELECT und AS CODIGO_und, " &
				  + "DESC_unidad AS DESCRIPCION_unidad " &
				  + "FROM unidad " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.und2			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		return
	
	case "cnta_prsp"
		ls_sql = "SELECT cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "DESCripcion AS DESCRIPCION_cnta_prsp " &
				  + "FROM presupuesto_cuenta " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		return
	
end choose
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Equivalencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeIcons!"
long picturemaskcolor = 536870912
dw_equivalencias dw_equivalencias
end type

on tabpage_6.create
this.dw_equivalencias=create dw_equivalencias
this.Control[]={this.dw_equivalencias}
end on

on tabpage_6.destroy
destroy(this.dw_equivalencias)
end on

type dw_equivalencias from u_dw_abc within tabpage_6
event ue_display ( string as_columna,  long al_row )
integer width = 2633
integer height = 964
integer taborder = 20
string dataobject = "d_abc_articulo_equivalencias_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_und

choose case lower(as_columna)
		
	case "cod_equiva"
		ls_sql = "SELECT cod_art AS CODIGO_equivalencia, " &
				  + "DESC_art AS DESCRIPCION_articulo, " &
				  + "und AS unidad " &
				  + "FROM articulo " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, &
					ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.cod_equiva	[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			this.ii_update = 1
		end if
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1	
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string 	ls_null, ls_desc, ls_und, ls_cod_art

SetNull(ls_null)

if dwo.name = 'cat_art' then
	
	Select desc_art, und
		into :ls_desc, :ls_und
	from articulo
	where cod_art = :data
	  and flag_estado = '1';	
	
	if SQLCA.SQLCode = 100 then
		messagebox( "Error", "Codigo de articulo no existe o no esta activo", exclamation!)
		this.object.cod_equiva	[row] = ls_null
		this.object.desc_art		[row] = ls_null
		this.object.und			[row] = ls_null
		return 1
	end if

	this.object.desc_categoria	[row] = ls_desc
	this.object.und				[row] = ls_und
end if
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_cod_art

ls_cod_art = idw_master.object.cod_Art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo')
	return
end if

if idw_master.GetRow() = 0 then return

this.object.cod_art [al_row] = ls_cod_art
end event

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Composición de ~r~nArtículos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Asterisk!"
long picturemaskcolor = 536870912
string powertiptext = "Te permite indicar la composición de un artículo (por ejemplo para los Kits o juegos completos)"
dw_art_composicion dw_art_composicion
end type

on tabpage_10.create
this.dw_art_composicion=create dw_art_composicion
this.Control[]={this.dw_art_composicion}
end on

on tabpage_10.destroy
destroy(this.dw_art_composicion)
end on

type dw_art_composicion from u_dw_abc within tabpage_10
integer width = 3173
integer height = 1200
string dataobject = "d_articulo_composicion_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
Date		ld_fecha1, ld_fecha2
Datawindow ldw

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if lower(dwo.name) = 'fecha_inicio' then
	
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
elseif lower(dwo.name) = 'fecha_fin' then
	
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
end if

if lower(dwo.name) = 'fecha_inicio' or &
	lower(dwo.name) = 'fecha_fin' then
	
	ld_fecha1 = Date(this.object.fecha_inicio[row])
	ld_fecha2 = Date(this.object.fecha_fin	[row]	)
	
	if IsNull(ld_fecha1) or IsNull(ld_fecha2) then return
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso','Rango de Fecha Invalido')
	end if
	
	return
end if
	
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_cod_art

if idw_master.GetRow() = 0 then return

ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo', StopSign!)
	return
end if

this.object.cod_art 				[al_row] = ls_cod_art
this.object.cod_usr 				[al_row] = gs_user
this.object.cantidad 			[al_row] = 0.00

end event

event ue_display;call super::ue_display;// Abre ventana de ayuda 
string			ls_sql, ls_codigo, ls_data, ls_componente
str_Articulo	lstr_articulo

if idw_master.getRow() = 0 then return

choose case lower(as_columna)
	case "componente"
		/*************************************************************/
		//De acuerdo al factor Saldo Total aparece la ventana correcta
		/*************************************************************/
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
	
		if lstr_articulo.b_Return then
			this.object.componente			[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			this.object.und					[al_row] = lstr_articulo.und
			
			this.ii_update = 1
		end if

	case "und"
		ls_componente = this.object.componente [al_row]
		
		if IsNull(ls_componente) or trim(ls_componente) = '' then
			rollback;
			this.object.und			[al_row] = gnvo_app.is_null
			MessageBox('Error', 'Debe especificar primero el componente, por favor verifique')
			this.setColumn('componente')
			return
		end if
		
		ls_sql = "select au.und as unidad, " &
				 + "u.desc_unidad as desc_unidad " &
				 + "  from articulo_und au, " &
				 + "       unidad       u " &
				 + " where au.und = u.und " &
				 + "   and au.cod_art = '" + ls_componente + "'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.und				[al_row] = ls_codigo
			this.ii_update = 1
		end if		
end choose
end event

event itemchanged;call super::itemchanged;String ls_data, ls_und, ls_componente

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'componente'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_data, :ls_und
		  from articulo
		 Where cod_art = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.componente	[row] = gnvo_app.is_null
			this.object.desc_art		[row] = gnvo_app.is_null
			this.object.und			[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Artículo ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_art			[row] = ls_data
		this.object.und				[row] = ls_und
		this.object.cantidad			[row] = 1

	CASE 'und'
		
		ls_componente = this.object.componente [row]
		
		if IsNull(ls_componente) or trim(ls_componente) = '' then
			rollback;
			this.object.und			[row] = gnvo_app.is_null
			MessageBox('Error', 'Debe especificar primero el componente, por favor verifique')
			this.setColumn('componente')
			return 1
		end if
		
		// Verifica que codigo ingresado exista			
		Select u.des_unidad
	     into :ls_data
		  from articulo_und 	au,
		  		 unidad			u
		 Where au.und			= u.und	
		   and au.cod_art  	= :ls_componente
		   and au.und			= :data 
		   and u.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.und	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Unidad ' + data + ' no existe, no esta activo ' &
									+ 'o no le corresponde al articulo ' + ls_componente + ', por favor verifique')
			return 1
		end if

END CHOOSE
end event

type tabpage_11 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Artículos de~r~nBonificacion"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Blob!"
long picturemaskcolor = 536870912
dw_art_bonific dw_art_bonific
end type

on tabpage_11.create
this.dw_art_bonific=create dw_art_bonific
this.Control[]={this.dw_art_bonific}
end on

on tabpage_11.destroy
destroy(this.dw_art_bonific)
end on

type dw_art_bonific from u_dw_abc within tabpage_11
integer width = 3173
integer height = 1200
string dataobject = "d_articulo_bonificacion_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event itemchanged;call super::itemchanged;String ls_data, ls_und, ls_art_bonific

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'art_bonific'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_data, :ls_und
		  from articulo
		 Where cod_art = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.art_bonific	[row] = gnvo_app.is_null
			this.object.desc_art		[row] = gnvo_app.is_null
			this.object.und			[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Artículo ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_art			[row] = ls_data
		this.object.und				[row] = ls_und
		this.object.cantidad			[row] = 1

	CASE 'und'
		
		ls_art_bonific = this.object.art_bonific [row]
		
		if IsNull(ls_art_bonific) or trim(ls_art_bonific) = '' then
			rollback;
			this.object.und			[row] = gnvo_app.is_null
			MessageBox('Error', 'Debe especificar primero el componente, por favor verifique')
			this.setColumn('art_bonific')
			return 1
		end if
		
		// Verifica que codigo ingresado exista			
		Select u.des_unidad
	     into :ls_data
		  from articulo_und 	au,
		  		 unidad			u
		 Where au.und			= u.und	
		   and au.cod_art  	= :ls_art_bonific
		   and au.und			= :data 
		   and u.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.und	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Unidad ' + data + ' no existe, no esta activo ' &
									+ 'o no le corresponde al articulo ' + ls_art_bonific + ', por favor verifique')
			return 1
		end if

END CHOOSE
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_cod_art

if idw_master.GetRow() = 0 then return

ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo', StopSign!)
	return
end if



this.object.cod_art [al_row] = ls_cod_art
this.object.cod_usr [al_row] = gs_user

end event

event ue_display;call super::ue_display;// Abre ventana de ayuda 
string			ls_sql, ls_codigo, ls_data, ls_art_bonific
str_Articulo	lstr_articulo

if idw_master.getRow() = 0 then return

choose case lower(as_columna)
	case "art_bonific"
		/*************************************************************/
		//De acuerdo al factor Saldo Total aparece la ventana correcta
		/*************************************************************/
		lstr_articulo = gnvo_app.almacen.of_get_articulo_bonif( )
	
		if lstr_articulo.b_Return then
			this.object.art_bonific			[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			this.object.und					[al_row] = lstr_articulo.und
			
			this.ii_update = 1
		end if

	case "und"
		ls_art_bonific = this.object.art_bonific [al_row]
		
		if IsNull(ls_art_bonific) or trim(ls_art_bonific) = '' then
			rollback;
			this.object.und			[al_row] = gnvo_app.is_null
			MessageBox('Error', 'Debe especificar primero el Codigo de Articulo, por favor verifique')
			this.setColumn('art_bonific')
			return
		end if
		
		ls_sql = "select au.und as unidad, " &
				 + "u.desc_unidad as desc_unidad " &
				 + "  from articulo_und au, " &
				 + "       unidad       u " &
				 + " where au.und = u.und " &
				 + "   and au.cod_art = '" + ls_art_bonific + "'" &
				 + "   and u.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.und				[al_row] = ls_codigo
			this.ii_update = 1
		end if		
end choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Saldos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Asterisk!"
long picturemaskcolor = 536870912
dw_saldos dw_saldos
end type

on tabpage_3.create
this.dw_saldos=create dw_saldos
this.Control[]={this.dw_saldos}
end on

on tabpage_3.destroy
destroy(this.dw_saldos)
end on

type dw_saldos from u_dw_abc within tabpage_3
integer width = 3621
integer height = 1532
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_saldos_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

event buttonclicked;call super::buttonclicked;idw_master.AcceptText()
idw_saldos.Accepttext( )

if row = 0 then return

choose case lower(dwo.name)
	case "b_actualizar1"
		of_actualizar()
end choose

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.costo_prom_sol 	[al_row] = 0
this.object.costo_prom_dol 	[al_row] = 0
this.object.costo_ult_compra 	[al_row] = ldc_precio_cmp_ref
this.object.moneda_compra 		[al_row] = gnvo_app.is_dolares
end event

event itemchanged;call super::itemchanged;idw_master.ii_update = 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "moneda_compra"
		ls_sql = "select m.cod_moneda as codigo_moneda, " &
				 + "m.descripcion as desc_moneda " &
				 + "from moneda m " &
				 + "where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.moneda_compra	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		

end choose
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Configuración x Almacén"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateLibrary5!"
long picturemaskcolor = 536870912
dw_ubicacion dw_ubicacion
end type

on tabpage_4.create
this.dw_ubicacion=create dw_ubicacion
this.Control[]={this.dw_ubicacion}
end on

on tabpage_4.destroy
destroy(this.dw_ubicacion)
end on

type dw_ubicacion from u_dw_abc within tabpage_4
integer width = 2976
integer height = 1268
integer taborder = 20
string dataobject = "d_abc_articulo_ubicacion"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_reposicion		[al_row] = '0'
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und_negocio'
		ls_sql = "select und_negocio as codigo, desc_und_negocio as nombre_unidad_negocio from unidad_negocio"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.und_negocio[row] = ls_return1
		this.object.desc_und_negocio[row] = ls_return2
		this.ii_update = 1
end choose


end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Saldos x Almacen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Count!"
long picturemaskcolor = 536870912
dw_saldos_almacen dw_saldos_almacen
end type

on tabpage_5.create
this.dw_saldos_almacen=create dw_saldos_almacen
this.Control[]={this.dw_saldos_almacen}
end on

on tabpage_5.destroy
destroy(this.dw_saldos_almacen)
end on

type dw_saldos_almacen from u_dw_abc within tabpage_5
integer y = 4
integer width = 3813
integer height = 1432
integer taborder = 20
string dataobject = "d_abc_art_sldo_almacen_grd"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event clicked;call super::clicked;f_select_current_row( this)
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Precios Pactados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Compute5!"
long picturemaskcolor = 67108864
string powertiptext = "Precios Pactados"
dw_precios_pactados dw_precios_pactados
end type

on tabpage_7.create
this.dw_precios_pactados=create dw_precios_pactados
this.Control[]={this.dw_precios_pactados}
end on

on tabpage_7.destroy
destroy(this.dw_precios_pactados)
end on

type dw_precios_pactados from u_dw_abc within tabpage_7
event ue_display ( string as_columna,  long al_row )
integer width = 3173
integer height = 1200
integer taborder = 20
string dataobject = "d_art_precio_pactado_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "RUC AS RUC_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case 'cod_moneda'

		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion_moneda " &
				  + "FROM moneda " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
Date		ld_fecha1, ld_fecha2
Datawindow ldw

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if lower(dwo.name) = 'fecha_inicio' then
	
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
elseif lower(dwo.name) = 'fecha_fin' then
	
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
end if

if lower(dwo.name) = 'fecha_inicio' or &
	lower(dwo.name) = 'fecha_fin' then
	
	ld_fecha1 = Date(this.object.fecha_inicio[row])
	ld_fecha2 = Date(this.object.fecha_fin	[row]	)
	
	if IsNull(ld_fecha1) or IsNull(ld_fecha2) then return
	
	if ld_fecha2 < ld_fecha1 then
		MessageBox('Aviso','Rango de Fecha Invalido')
	end if
	
	return
end if
	
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event ue_insert_pre;call super::ue_insert_pre;Date ld_null
string ls_cod_art

SetNull(ld_null)
if idw_master.GetRow() = 0 then return

ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo')
	return
end if



this.object.cod_art [al_row] = ls_cod_art

this.object.flag_estado 		[al_row] = '1'
this.object.cod_usr 				[al_row] = gs_user
this.object.flag_replicacion 	[al_row] = '1'
this.object.precio_compra 		[al_row] = 0
this.object.fecha_inicio 		[al_row] = ld_null
this.object.fecha_fin 			[al_row] = ld_null
end event

event itemchanged;call super::itemchanged;string 	ls_null, ls_desc
Long		ll_count
Date		ld_Fecha1, ld_fecha2
SetNull(ls_null)

This.AcceptText()

choose case lower(dwo.name)
	case 'proveedor'
		select nom_proveedor
			into :ls_desc
		from proveedor
		where flag_estado = '0'
		  and proveedor = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Proveedor no existe o no esta activo')
			this.object.proveedor 		[row] = ls_null
			this.object.nom_proveedor 	[row] = ls_null
		end if
		
		this.object.nom_proveedor [row] = ls_desc
	
	case 'fecha_inicio', 'fecha_fin'
		
		ld_fecha1 = Date(this.object.fecha_inicio[row])
		ld_fecha2 = Date(this.object.fecha_fin	[row]	)
		
		if IsNull(ld_fecha1) or IsNull(ld_fecha2) then return
		
		if ld_fecha2 < ld_fecha1 then
			MessageBox('Aviso','Rango de Fecha Invalido')
			SetNull(ld_fecha1)
			this.object.fecha_inicio[row] = ld_fecha1
			this.SetColumn(lower(dwo.name))
			return 0
		end if
		
		return		
	case 'cod_moneda'
		
		select count(*)
			into :ll_count
		from moneda
		where cod_moneda = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Moneda no existe')
			this.object.cod_moneda 		[row] = ls_null
		end if
		
		this.object.nom_proveedor [row] = ls_desc
		
end choose



end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 4169
integer height = 1624
long backcolor = 79741120
string text = "Centro de ~r~nBeneficio"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Application!"
long picturemaskcolor = 536870912
dw_centro_benef dw_centro_benef
end type

on tabpage_9.create
this.dw_centro_benef=create dw_centro_benef
this.Control[]={this.dw_centro_benef}
end on

on tabpage_9.destroy
destroy(this.dw_centro_benef)
end on

type dw_centro_benef from u_dw_abc within tabpage_9
integer width = 3173
integer height = 1200
string dataobject = "d_art_precio_pactado_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_desc

This.AcceptText()

choose case lower(dwo.name)
	case 'centro_benef'
		select desc_Centro
			into :ls_desc
		from centro_beneficio
		where flag_estado = '1'
		  and centro_benef = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Centro de Beneficio no existe o no esta activo', StopSign!)
			this.object.centro_benef 	[row] = gnvo_app.is_null
			this.object.desc_centro 	[row] = gnvo_app.is_null
		end if
		
		this.object.desc_centro [row] = ls_desc

		
end choose



end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_cod_art

if idw_master.GetRow() = 0 then return

ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
if trim(ls_Cod_Art) = '' or IsNull(ls_Cod_art) then
	MessageBox('Aviso', 'Debe definir codigo de Articulo', StopSign!)
	return
end if



this.object.cod_art [al_row] = ls_cod_art

end event

event ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "centro_benef"
		ls_sql = "select cb.centro_benef as centro_benef, " &
				 + "cb.desc_centro as desc_centro_beneficio " &
				 + "from centro_beneficio cb " &
				 + "where cb.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		
end choose
end event

type st_1 from statictext within w_cm010_articulos
integer width = 3205
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "ARTICULOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

