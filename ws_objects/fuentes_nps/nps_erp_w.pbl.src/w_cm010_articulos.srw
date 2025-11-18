$PBExportHeader$w_cm010_articulos.srw
forward
global type w_cm010_articulos from w_abc
end type
type tab_1 from tab within w_cm010_articulos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_master dw_master
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_6 from userobject within tab_1
end type
type dw_equiv from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_equiv dw_equiv
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_ubi from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_ubi dw_ubi
end type
type tabpage_5 from userobject within tab_1
end type
type dw_saldos from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_saldos dw_saldos
end type
type tabpage_7 from userobject within tab_1
end type
type dw_prec_p from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_prec_p dw_prec_p
end type
type tab_1 from tab within w_cm010_articulos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_6 tabpage_6
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
end type
type st_1 from statictext within w_cm010_articulos
end type
end forward

global type w_cm010_articulos from w_abc
integer width = 3867
integer height = 1996
string title = "Articulos [CM010]"
string menuname = "m_mtto_lista"
tab_1 tab_1
st_1 st_1
end type
global w_cm010_articulos w_cm010_articulos

type variables
u_dw_abc idw_master, idw_2, idw_3, idw_ubi, &
			idw_saldos, idw_equiv, idw_prec_p
string 	is_Action, is_salir
Integer	il_tam_max_cod_Art
decimal	ldc_PRECIO_CMP_REF
end variables

forward prototypes
public function string of_next_cod_art (string as_sub_categ)
public subroutine of_retrieve (string as_cod_art)
public function decimal of_ult_precio_comp (string as_cod_art)
public subroutine of_set_modify ()
public function integer of_set_cambios ()
public function integer of_get_param ()
public subroutine of_actualizar ()
end prototypes

public function string of_next_cod_art (string as_sub_categ);string 	ls_codigo, ls_sub_categ
Long		ll_cont, ll_long_cod_art, ll_find, ll_long

ls_sub_categ = trim(as_sub_categ) + '%'
ll_long	= Len(trim(as_sub_categ)) + 1

// Extraigo el ultimo codigo de articulo de la tabla articulo
select cod_art
	into :ls_codigo
from (select cod_art
		from articulo
		where cod_Art Like :ls_sub_categ
		order by cod_art desc)
where rownum = 1;

if SQLCA.SQlcode = -1 then
	MessageBox('Error', SQLCA.SQLErrtext)
	SetNull(ls_codigo)
	return ls_codigo
end if

if SQLCA.SQlcode = 100 then
	ll_cont = 0
else
	ls_codigo = trim(ls_codigo)
	ll_find = Pos(ls_codigo, '.')
	ll_long_cod_art = len(ls_codigo)
	ll_cont = Long( mid(ls_codigo, ll_find + 1, ll_long_cod_art))
end if

ll_cont ++

if il_tam_max_cod_art > ll_long then
	ls_codigo = trim(as_sub_Categ) + '.' + string(ll_cont, Fill('0', il_tam_max_cod_art - ll_long ))
else
	ls_codigo = trim(as_sub_Categ) + '.' + string(ll_cont, '0000')
end if

return ls_codigo
end function

public subroutine of_retrieve (string as_cod_art);//Maestro
idw_master.retrieve(as_cod_art)

//Max Tamao del Cod_art
if il_tam_max_cod_art > 0 then
	idw_master.object.cod_art.edit.Limit = il_tam_max_cod_art
end if

// lee dw_ubicacion
idw_ubi.retrieve( as_cod_art)	
// Lee los saldos 
idw_saldos.retrieve( as_cod_art)	
// Lee los equivalentes
idw_equiv.retrieve( as_cod_art)	
//Lee los precios pactados
idw_prec_p.retrieve( as_cod_art)	

idw_master.ii_update = 0
idw_master.ii_protect = 0
idw_master.of_protect()

idw_2.ii_update = 0
idw_2.ii_protect = 0
idw_2.of_protect()

idw_3.ii_update = 0
idw_3.ii_protect = 0
idw_3.of_protect()

idw_ubi.ii_update = 0
idw_ubi.ii_protect = 0
idw_ubi.of_protect()

idw_saldos.ii_update = 0
idw_saldos.ii_protect = 0
idw_saldos.of_protect()

idw_equiv.ii_update = 0
idw_equiv.ii_protect = 0
idw_equiv.of_protect()

idw_prec_p.ii_update = 0
idw_prec_p.ii_protect = 0
idw_prec_p.of_protect()

is_action = 'open'
//Aplicar los cambios en los campos de acuerdo a los flags
this.of_set_cambios( )
//of_actualizar()

end subroutine

public function decimal of_ult_precio_comp (string as_cod_art);String	ls_mensaje
decimal	ldc_prec_ult_comp

//create or replace function USF_ALM_ULT_COMP(
//       asi_cod_Art in articulo.cod_Art%TYPE
//) return number is

DECLARE USF_ALM_ULT_COMP PROCEDURE FOR
	USF_ALM_ULT_COMP( :as_cod_art );

EXECUTE USF_ALM_ULT_COMP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_ALM_ULT_COMP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(ldc_prec_ult_comp)
	return ldc_prec_ult_comp
END IF

FETCH USF_ALM_ULT_COMP INTO :ldc_prec_ult_comp;
CLOSE USF_ALM_ULT_COMP;

return ldc_prec_ult_comp


end function

public subroutine of_set_modify ();//Saldo minimo
idw_ubi.Modify("sldo_minimo.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubi.Modify("sldo_minimo.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

//Saldo Maximo
idw_ubi.Modify("sldo_maximo.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubi.Modify("sldo_maximo.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

//Cantidad a Comprar
idw_ubi.Modify("cnt_compra_rec.Protect ='1~tIf(IsNull(flag_reposicion),1,0)'")
idw_ubi.Modify("cnt_compra_rec.Background.color ='1~tIf(IsNull(flag_reposicion), RGB(192,192,192), RGB(255,255,255))'")

idw_ubi.SetColumn('ubicacion')
end subroutine

public function integer of_set_cambios ();string 	ls_flag_reposicion, ls_flag_und2, ls_flag_critico
Long		ll_row

if is_action <> 'open' then return 0

if idw_2.GetRow() = 0 then return 0

ll_row = idw_2.GetRow()

ls_flag_reposicion = idw_2.object.flag_reposicion[ll_row]
ls_flag_critico	 = idw_2.object.flag_critico	[ll_row]
ls_flag_und2	 	 = idw_2.object.flag_und2	[ll_row]

if isNull(ls_flag_reposicion) then 
	ls_flag_reposicion = '0'
	idw_2.object.flag_reposicion	[ll_row]
	idw_2.ii_update = 1
end if

if isNull(ls_flag_critico) then 
	ls_flag_critico = '0'
	idw_2.object.flag_critico	[ll_row]
	idw_2.ii_update = 1
end if

if isNull(ls_flag_und2) then 
	ls_flag_critico = '0'
	idw_2.object.flag_und2	[ll_row]
	idw_2.ii_update = 1
end if

if ls_flag_reposicion = '0' then
	idw_2.Object.sldo_minimo.Protect = 1
	idw_2.Object.sldo_maximo.Protect = 1
	idw_2.Object.cnt_compra_rec.Protect = 1
	idw_2.object.sldo_minimo.EditMask.required = 'Yes'
	idw_2.object.sldo_maximo.EditMask.required = 'Yes'
	idw_2.object.cnt_compra_rec.EditMask.required = 'Yes'
else
	idw_2.Object.sldo_minimo.Protect = 0
	idw_2.Object.sldo_maximo.Protect = 0
	idw_2.Object.cnt_compra_rec.Protect = 0
	idw_2.object.sldo_minimo.EditMask.required = 'No'
	idw_2.object.sldo_maximo.EditMask.required = 'No'
	idw_2.object.cnt_compra_rec.EditMask.required = 'No'
end if

// Si tiene activo el fla reposicion, entonces 
// no es necesario activar los campos, porque ya los 
// tiene activo

if ls_flag_reposicion = '0' then 
	if ls_flag_critico = '0' then
		idw_2.Object.sldo_minimo.Protect = 1
		idw_2.Object.cnt_compra_rec.Protect = 1
		idw_2.object.sldo_minimo.EditMask.required = 'Yes'
		idw_2.object.cnt_compra_rec.EditMask.required = 'Yes'
	else
		idw_2.Object.sldo_minimo.Protect = 0
		idw_2.Object.cnt_compra_rec.Protect = 0
		idw_2.object.sldo_minimo.EditMask.required = 'No'
		idw_2.object.cnt_compra_rec.EditMask.required = 'No'
	end if
end if
	
if ls_flag_und2 = '0' then
	idw_2.Object.und2.Protect = 1
	idw_2.Object.factor_conv_und.Protect = 1
	idw_2.object.und2.edit.required = 'Yes'
	idw_2.object.factor_conv_und.EditMask.required = 'Yes'
else
	idw_2.Object.und2.Protect = 0
	idw_2.Object.factor_conv_und.Protect = 0
	idw_2.object.und2.edit.required = 'No'
	idw_2.object.factor_conv_und.EditMask.required = 'No'
end if

return 1

end function

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
SELECT 	NVL(tam_max_cod_art, 0), NVL(PRECIO_CMP_REF, -1)
	INTO 	:il_tam_max_cod_art, :ldc_precio_cmp_ref
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	ls_mensaje = "no ha definido parametros en Logparam"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return 0
end if

return 1
end function

public subroutine of_actualizar ();String 	ls_cod_art
Decimal	ldc_old_precio, ldc_ult_prec_comp

ls_cod_art = idw_3.object.cod_Art [idw_3.GetRow()]
if ls_cod_art = '' or IsNull(ls_cod_art) then 
	MessageBox('Aviso', 'Codigo de Articulo no definido')
	return
end if

ldc_old_precio = dec(idw_3.object.costo_ult_compra[idw_3.GetRow()])

ldc_ult_prec_comp = of_ult_precio_comp(ls_cod_art)

if IsNull(ldc_ult_prec_comp) then ldc_ult_prec_comp = ldc_precio_cmp_ref

if ldc_old_precio <> ldc_ult_prec_comp then
	MessageBox('Aviso', 'Actualizando Precio de Ultima Compra en Dolares')
	idw_3.object.costo_ult_compra[idw_saldos.GetRow()] = ldc_ult_prec_comp
	idw_3.ii_update = 1
end if
end subroutine

on w_cm010_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
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

event ue_open_pre;call super::ue_open_pre;//f_centrar( this)

idw_master 	= tab_1.tabpage_1.dw_master
idw_2			= tab_1.tabpage_2.dw_2
idw_3			= tab_1.tabpage_3.dw_3
idw_ubi		= tab_1.tabpage_4.dw_ubi
idw_saldos	= tab_1.tabpage_5.dw_saldos
idw_equiv	= tab_1.tabpage_6.dw_equiv
idw_prec_p	= tab_1.tabpage_7.dw_prec_p

idw_1 = tab_1.tabpage_1.dw_master             // asignar dw corriente

idw_1.SetTransObject(SQLCA)
idw_saldos.SetTransObject(SQLCA)
idw_ubi.SetTransObject(SQLCA)
idw_equiv.SetTransObject(SQLCA)
idw_prec_p.SetTransObject(SQLCA)

idw_master.of_protect() 
idw_2.of_protect() 
idw_equiv.of_protect()
idw_prec_p.of_protect()

ii_pregunta_delete = 1 
// ii_help = 101           // help topic

// Busco primer registro 
String ls_articulo
Select cod_art 
	into :ls_articulo 
from articulo 
where rownum = 1;

of_retrieve(ls_articulo)
end event

event ue_insert;call super::ue_insert;Long  ll_row
string ls_cod_art

this.event ue_update_request()
if idw_1 = idw_master then
	idw_master.reset()
	idw_ubi.Reset()
	idw_2.Reset()
	idw_3.Reset()
	idw_saldos.Reset()
	idw_equiv.Reset()
	idw_prec_p.Reset()

	ll_row = idw_master.Event ue_insert()
	IF ll_row <> -1 THEN
		idw_2.ii_protect = 1
		idw_2.of_protect()
		THIS.EVENT ue_insert_pos(ll_row)
		is_Action = 'new'
	end if
	
elseif idw_1 = idw_equiv then
	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [idw_master.GetRow()]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if
	
	idw_equiv.event ue_insert()
	
elseif idw_1 = idw_prec_p then	
	if idw_master.GetRow() = 0 then return
	ls_cod_art = idw_master.object.cod_art [idw_master.GetRow()]
	if trim(ls_cod_art) = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Para Ingresar un registro aqui, no debe estar en blanco el Codigo del Articulo')
		return	
	end if

	idw_prec_p.event ue_insert()
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
string ls_msg1, ls_msg2

idw_master 	= tab_1.tabpage_1.dw_master
idw_2			= tab_1.tabpage_2.dw_2
idw_3			= tab_1.tabpage_3.dw_3
idw_ubi		= tab_1.tabpage_4.dw_ubi
idw_saldos	= tab_1.tabpage_5.dw_saldos
idw_equiv	= tab_1.tabpage_6.dw_equiv
idw_prec_p 	= tab_1.tabpage_7.dw_prec_p

idw_master.AcceptText()
idw_2.AcceptText()
idw_equiv.AcceptText()
idw_prec_p.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

//Graba el dw_master
IF idw_master.ii_update = 1 THEN
	IF idw_master.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

//Graba el dw_2
IF idw_2.ii_update = 1 THEN
	IF idw_2.Update() = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Indicadores dw_2"
		ls_msg2 = "Se ha procedido al rollback"
	END IF
END IF

//Graba el dw_3
IF idw_3.ii_update = 1 THEN
	IF idw_3.Update() = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Indicadores dw_3"
		ls_msg2 = "Se ha procedido al rollback"
	END IF
END IF

//Graba el dw_equiv 
IF idw_equiv.ii_update = 1 THEN	
	IF idw_equiv.Update() = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion equivalencias"
		ls_msg2 = "Se ha procedido al rollback"
	END IF
END IF

//Graba el dw_precio_p
IF idw_prec_p.ii_update = 1 THEN	
	IF idw_prec_p.Update() = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion equivalencias"
		ls_msg2 = "Se ha procedido al rollback, idw_pre_p"
	END IF
END IF

//Graba el dw_ubi
IF idw_ubi.ii_update = 1 THEN	
	IF idw_ubi.Update() = -1 then		// Grabacion del detalle		
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Ubicaciones"
		ls_msg2 = "Se ha procedido al rollback, dw_ubi"
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	if idw_master.GetRow() > 0 then
		of_retrieve(idw_master.object.cod_art[idw_master.GetRow()])
	end if
	idw_master.ii_update = 0
	idw_2.ii_update 		= 0
	idw_3.ii_update 		= 0
	idw_equiv.ii_update 	= 0
	idw_prec_p.ii_update = 0
	
	is_action = 'open'
	
	// activa opciones de menu
	m_master.m_file.m_basedatos.m_insertar.enabled = true	
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
	m_master.m_file.m_basedatos.m_modificar.enabled = true
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2,exclamation!)
END IF
end event

event ue_dw_share;call super::ue_dw_share;// Compartir el dw_master con dws secundarios

Integer li_share_status
li_share_status = idw_master.ShareData (idw_2)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW2",exclamation!)
	RETURN
END IF
li_share_status = idw_master.ShareData (idw_3)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW3",exclamation!)
	RETURN
END IF
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

if idw_1 = idw_ubi and idw_ubi.ii_protect = 0 then
	of_set_modify()
end if

if idw_1 = idw_2 and idw_2.ii_protect = 0 then
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

idw_1.AcceptText()
idw_prec_p.Accepttext( )
idw_master.Accepttext( )
idw_equiv.accepttext( )
idw_3.Accepttext( )

if idw_master.GetRow() = 0 and is_action <> 'del' then return

if f_row_Processing( idw_master, "form") <> true then	
	tab_1.Selectedtab = 1
	return
end if

if f_row_Processing( idw_equiv, "tabular") <> true then 
	tab_1.Selectedtab = 3
	return
end if

if f_row_Processing( idw_prec_p, "tabular") <> true then	
	tab_1.Selectedtab = 7
	return
end if

if f_row_Processing( idw_3, "form") <> true then 
	tab_1.Selectedtab = 4
	return
end if

if idw_3.GetRow() = 0 and is_Action <> 'del' then 
	MessageBox('Error', 'No hay registro en la solapa SALDOS')
	return
end if

if is_action = 'new' then
	//Verifico que no se duplique el codigo de articulo
	ls_cod_art = idw_master.object.cod_art[idw_master.GetRow()]
	ls_sub_Cat = idw_master.object.sub_cat_art[idw_master.GetRow()]
	
	select count(*)
	  into :ll_count
	  from articulo
	  where cod_Art = :ls_cod_art;
	
	if ll_count > 0 then
		ls_cod_art = of_next_cod_art(ls_sub_cat)
		idw_master.object.cod_art[idw_master.GetRow()] = ls_cod_art
		idw_master.ii_update = 1
	end if
end if

ib_update_check = True

idw_master.of_set_flag_replicacion()
idw_2.of_set_flag_replicacion()
idw_3.of_set_flag_replicacion()
idw_ubi.of_set_flag_replicacion()
idw_saldos.of_set_flag_replicacion()
idw_equiv.of_set_flag_replicacion()
idw_prec_p.of_set_flag_replicacion()
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_master.ii_update = 1 OR &
	idw_2.ii_update 		= 1 OR &
	idw_3.ii_update 		= 1 OR &
	idw_equiv.ii_update 	= 1 OR &
	idw_prec_p.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_master.ii_update = 0	
		idw_2.ii_update 		= 0
		idw_3.ii_update 		= 0
		idw_equiv.ii_update 	= 0
		idw_prec_p.ii_update = 0
	END IF
END IF

end event

event resize;call super::resize;idw_master 	= tab_1.tabpage_1.dw_master
idw_2			= tab_1.tabpage_2.dw_2
idw_3			= tab_1.tabpage_3.dw_3
idw_ubi		= tab_1.tabpage_4.dw_ubi
idw_saldos	= tab_1.tabpage_5.dw_saldos
idw_equiv	= tab_1.tabpage_6.dw_equiv
idw_prec_p 	= tab_1.tabpage_7.dw_prec_p

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_master.width = tab_1.width - idw_master.X - 40
idw_master.height = tab_1.height - idw_master.y - 140

idw_2.width = tab_1.width - idw_2.X - 40
idw_2.height = tab_1.height - idw_2.y - 140

idw_3.width = tab_1.width - idw_3.X - 40
idw_3.height = tab_1.height - idw_3.y - 140

idw_ubi.width = tab_1.width - idw_ubi.X - 40
idw_ubi.height = tab_1.height - idw_ubi.y - 140

idw_saldos.width = tab_1.width - idw_saldos.X - 40
idw_saldos.height = tab_1.height - idw_saldos.y - 140

idw_equiv.width = tab_1.width - idw_equiv.X - 40
idw_equiv.height = tab_1.height - idw_equiv.y - 140

idw_prec_p.width = tab_1.width - idw_prec_p.X - 40
idw_prec_p.height = tab_1.height - idw_prec_p.y - 140
end event

event open;call super::open;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

idw_master 	= tab_1.tabpage_1.dw_master
idw_2			= tab_1.tabpage_2.dw_2
idw_3			= tab_1.tabpage_3.dw_3
idw_ubi		= tab_1.tabpage_4.dw_ubi
idw_saldos	= tab_1.tabpage_5.dw_saldos
idw_equiv	= tab_1.tabpage_6.dw_equiv
idw_prec_p 	= tab_1.tabpage_7.dw_prec_p

end event

event ue_delete;// Ancestor Script has been Override
Long  ll_row

if idw_1 <> idw_master then 
	MessageBox('Error', 'No esta permitida esta opción')
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

event ue_retrieve_list;//Override
Long ll_row
String ls_codsub

// Abre ventana de ayuda 
str_parametros sl_param

this.event dynamic ue_update_request()

OpenWithParm (w_pop_articulos, 'all' )  //this
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' then
	this.of_retrieve(sl_param.field_ret[1])
	is_action = 'open'
END IF
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

type p_pie from w_abc`p_pie within w_cm010_articulos
end type

type ole_skin from w_abc`ole_skin within w_cm010_articulos
end type

type uo_h from w_abc`uo_h within w_cm010_articulos
end type

type st_box from w_abc`st_box within w_cm010_articulos
end type

type phl_logonps from w_abc`phl_logonps within w_cm010_articulos
end type

type p_mundi from w_abc`p_mundi within w_cm010_articulos
end type

type p_logo from w_abc`p_logo within w_cm010_articulos
end type

type tab_1 from tab within w_cm010_articulos
integer x = 498
integer y = 264
integer width = 3205
integer height = 1444
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
tabpage_6 tabpage_6
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_6=create tabpage_6
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_6,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_6)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_7)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Datos Generales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
string powertiptext = "Datos Generales del Articulo"
dw_master dw_master
end type

on tabpage_1.create
this.dw_master=create dw_master
this.Control[]={this.dw_master}
end on

on tabpage_1.destroy
destroy(this.dw_master)
end on

type dw_master from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 2629
integer height = 952
boolean bringtotop = true
string dataobject = "d_abc_articulo_generales_ff"
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_art, ls_cod_art

choose case lower(as_columna)
		
	case "cat_art"
		ls_sql = "SELECT cat_art AS CODIGO_categoria, " &
				  + "DESC_categoria AS DESCRIPCION_categoria " &
				  + "FROM articulo_categ " &
				  + "where flag_servicio = '0'"
				 
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
				  + "DESC_SUB_CAT AS DESCRIPCION_sub_categoria " &
				  + "FROM articulo_sub_categ " &
				  + "where flag_servicio = '0'" &
				  + "and cat_Art = '" + ls_cat_art + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.sub_cat_art		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			this.ii_update = 1
			
			if is_action = 'new' then
				this.object.cod_art[al_row] = of_next_cod_art( ls_codigo )
			end if
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
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_clase	[al_row] = ls_codigo
			this.object.desc_clase	[al_row] = ls_data
			this.ii_update = 1
		end if
		return
		
		
end choose
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda
String 	ls_name, ls_prot, ls_cod_art, ls_docname, ls_named
Integer 	li_ano, li_value

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
END CHOOSE

end event

event itemchanged;call super::itemchanged;string 	ls_null, ls_desc, ls_cat, ls_cod_art
Long		ll_count

SetNull(ls_null)

if dwo.name = 'cat_art' then
	
	Select desc_categoria 
		into :ls_desc 
	from articulo_categ
	where cat_art = :data;	
	
	if SQLCA.SQLCode = 100 then
		messagebox( "Error", "Categoria no existe", exclamation!)
		this.object.cat_art			[row] = ls_null
		this.object.desc_categoria	[row] = ls_null
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
		this.object.sub_cat_art[row] = ls_null
		this.object.sub_cat_art[row] = ls_null
		return 1
	end if

	this.object.desc_sub_cat[row] = ls_desc	
	
	if is_action = 'new' then
		this.object.cod_art[row] = of_next_cod_art( data )
	end if
	
elseif dwo.name = 'cod_art' then
	// verifica si ya existe
	
	Select count( cod_art) 
		into :ll_count 
	from articulo
	where cod_art = :data;	
	
	if ll_count = 1 then
		messagebox( "Error", "Codigo de articulo ya esta definido", exclamation!)
		this.object.cod_art[row] = ls_null
		return 1
	end if	
	
elseif dwo.name = 'und' then
	
	select desc_unidad
		into :ls_desc
	from unidad
	where und = :data;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Codigo de unidad')
		this.object.und 			[row] = ls_null
		this.object.desc_unidad [row] = ls_null
		return 1
	end if
	
	this.object.desc_unidad [row] = ls_desc
	
elseif dwo.name = 'cod_clase' then
	
	select desc_clase
		into :ls_desc
	from articulo_clase
	where cod_clase = :data;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Codigo de clase')
		this.object.cod_clase 	[row] = ls_null
		this.object.desc_clase 	[row] = ls_null
		return 1
	end if
	
	this.object.desc_clase 		[row] = ls_desc

end if
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen			[al_row] = gnvo_app.is_origen
this.object.flag_estado			[al_row] = '1'
this.object.costo_prom_sol 	[al_row] = 0
this.object.costo_prom_dol 	[al_row] = 0
this.object.costo_ult_compra 	[al_row] = ldc_precio_cmp_ref

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

idw_3.of_protect()
is_action = 'new'
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Indicadores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CheckBox!"
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer width = 2610
integer height = 876
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_indicadores_ff"
borderstyle borderstyle = styleraised!
end type

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

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Equivalencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeIcons!"
long picturemaskcolor = 536870912
dw_equiv dw_equiv
end type

on tabpage_6.create
this.dw_equiv=create dw_equiv
this.Control[]={this.dw_equiv}
end on

on tabpage_6.destroy
destroy(this.dw_equiv)
end on

type dw_equiv from u_dw_abc within tabpage_6
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

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Saldos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Asterisk!"
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw_abc within tabpage_3
integer width = 2574
integer height = 1180
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_saldos_ff"
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
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Configuración x Almacén"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateLibrary5!"
long picturemaskcolor = 536870912
dw_ubi dw_ubi
end type

on tabpage_4.create
this.dw_ubi=create dw_ubi
this.Control[]={this.dw_ubi}
end on

on tabpage_4.destroy
destroy(this.dw_ubi)
end on

type dw_ubi from u_dw_abc within tabpage_4
integer width = 2976
integer height = 1268
integer taborder = 20
string dataobject = "d_abc_articulo_ubicacion"
boolean hscrollbar = true
boolean vscrollbar = true
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
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Saldos x Almacen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Count!"
long picturemaskcolor = 536870912
dw_saldos dw_saldos
end type

on tabpage_5.create
this.dw_saldos=create dw_saldos
this.Control[]={this.dw_saldos}
end on

on tabpage_5.destroy
destroy(this.dw_saldos)
end on

type dw_saldos from u_dw_abc within tabpage_5
integer y = 4
integer width = 2624
integer height = 968
integer taborder = 20
string dataobject = "d_abc_art_sldo_almacen_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event clicked;call super::clicked;f_select_current_row( this)
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3168
integer height = 1316
long backcolor = 79741120
string text = "Precios Pactados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Compute5!"
long picturemaskcolor = 67108864
string powertiptext = "Precios Pactados"
dw_prec_p dw_prec_p
end type

on tabpage_7.create
this.dw_prec_p=create dw_prec_p
this.Control[]={this.dw_prec_p}
end on

on tabpage_7.destroy
destroy(this.dw_prec_p)
end on

type dw_prec_p from u_dw_abc within tabpage_7
event ue_display ( string as_columna,  long al_row )
integer width = 3173
integer height = 1200
integer taborder = 20
string dataobject = "d_art_precio_pactado_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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
this.object.cod_usr 				[al_row] = gnvo_app.is_user
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

type st_1 from statictext within w_cm010_articulos
integer x = 1682
integer y = 156
integer width = 562
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
boolean enabled = false
string text = "ARTICULOS"
boolean focusrectangle = false
end type

