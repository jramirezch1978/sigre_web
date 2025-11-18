$PBExportHeader$w_cm911_reserv_automatica.srw
forward
global type w_cm911_reserv_automatica from w_abc
end type
type cbx_1 from checkbox within w_cm911_reserv_automatica
end type
type sle_reservacion from singlelineedit within w_cm911_reserv_automatica
end type
type st_1 from statictext within w_cm911_reserv_automatica
end type
type hpb_1 from hprogressbar within w_cm911_reserv_automatica
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm911_reserv_automatica
end type
type sle_descrip from singlelineedit within w_cm911_reserv_automatica
end type
type sle_almacen from singlelineedit within w_cm911_reserv_automatica
end type
type st_2 from statictext within w_cm911_reserv_automatica
end type
type dw_master from u_dw_abc within w_cm911_reserv_automatica
end type
type pb_2 from picturebutton within w_cm911_reserv_automatica
end type
type pb_1 from picturebutton within w_cm911_reserv_automatica
end type
type cb_leer from commandbutton within w_cm911_reserv_automatica
end type
type cb_selectall from commandbutton within w_cm911_reserv_automatica
end type
type cb_unselectall from commandbutton within w_cm911_reserv_automatica
end type
type cb_4 from commandbutton within w_cm911_reserv_automatica
end type
end forward

global type w_cm911_reserv_automatica from w_abc
integer width = 3342
integer height = 2184
string title = "Reservación Automática [cm911]"
string menuname = "m_salir"
cbx_1 cbx_1
sle_reservacion sle_reservacion
st_1 st_1
hpb_1 hpb_1
uo_fecha uo_fecha
sle_descrip sle_descrip
sle_almacen sle_almacen
st_2 st_2
dw_master dw_master
pb_2 pb_2
pb_1 pb_1
cb_leer cb_leer
cb_selectall cb_selectall
cb_unselectall cb_unselectall
cb_4 cb_4
end type
global w_cm911_reserv_automatica w_cm911_reserv_automatica

type variables
string is_reservacion
end variables

forward prototypes
public function integer of_set_numera (ref string as_nro)
public function integer of_act_saldo_reserv ()
public subroutine of_procesa_all ()
public subroutine of_retrieve ()
end prototypes

public function integer of_set_numera (ref string as_nro);// Numera documento
Long 		ll_long, ll_nro, j
string	ls_mensaje, ls_table

ls_table = 'LOCK TABLE num_reservacion IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_table ;
	
Select ult_nro 
	into :ll_nro 
from num_reservacion 
where origen = :gs_origen;
	
IF SQLCA.SQLCode = 100 then
	Insert into num_reservacion (origen, ult_nro)
		values( :gs_origen, 1);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
end if

// Asigna numero a cabecera
as_nro = String( ll_nro)	
ll_long = 10 - len( TRIM( gs_origen))
as_nro = TRIM( gs_origen) + f_llena_caracteres('0',Trim(as_nro),ll_long) 		

// Incrementa contador
Update num_reservacion 
	set ult_nro = ult_nro + 1 
 where origen = :gs_origen;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return 0
end if
	
return 1
end function

public function integer of_act_saldo_reserv ();string ls_mensaje

//CREATE OR REPLACE PROCEDURE usp_alm_act_saldo_reser(
//       asi_nada             in STRING
//) is

DECLARE 	usp_alm_act_saldo_reser PROCEDURE FOR
			usp_alm_act_saldo_reser( :gs_origen );

EXECUTE 	usp_alm_act_saldo_reser;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_reser: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE usp_alm_act_saldo_reser;

return 1

end function

public subroutine of_procesa_all ();Long		ll_count, ll_i, ll_nro_amp, ll_count2, ll_nro_item
String	ls_mensaje, ls_org_amp
Decimal	ldc_cantidad

if idw_1.RowCount() = 0 then return

ll_count = 0
for ll_i = 1 to idw_1.Rowcount()
	if idw_1.object.flag_estado[ll_i] = '1' then
		ll_count ++
	end if
next

if ll_count = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun registro')
	return
end if

if is_reservacion = '' then
	if of_set_numera(is_reservacion) = 0 then return
	sle_reservacion.text = is_reservacion

	//Creo un nuevo documento de reservacion
	//reservacion
	//Name             Type          Nullable Default Comments         
	//---------------- ------------- -------- ------- ---------------- 
	//NRO_RESERVACION  CHAR(10)                       nro reservacion  
	//COD_USR          CHAR(6)       Y                cod usuario      
	//FECHA            DATE          Y                fecha            
	//COD_ORIGEN       CHAR(2)       Y                codigo origen    
	//FLAG_ESTADO      CHAR(1)       Y        '1'     flag estado      
	//FLAG_REPLICACION CHAR(1)       Y        '1'     flag_replicacion 
	//OBS              VARCHAR2(100) Y                obs            
	insert into reservacion(nro_reservacion, cod_usr, fecha, 
		cod_origen, flag_estado, OBS, flag_automatico)
	values(
		:is_reservacion, :gs_user, sysdate, :gs_origen, '1', 
		'Reservación Generada Automáticamente desde el Módulo de Compras', '1');
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al insertar en Reservacion', ls_mensaje)
		return 
	else
		commit;
	end if
end if

hpb_1.visible = true
hpb_1.maxPosition  = ll_count

ll_count = 0
ll_count2 = 0

for ll_i = 1 to idw_1.RowCount()
	if idw_1.object.flag_estado[ll_i] = '1' then
		ll_count ++
		hpb_1.position = ll_count
		
		ldc_cantidad = Dec(idw_1.object.saldo_libre[ll_i])
		ls_org_amp	 = idw_1.object.cod_origen		[ll_i]
		ll_nro_amp	 = Long(idw_1.object.nro_mov	[ll_i])
		
		// Ahora inserto el detalle de la Reservacion
		// SQL> desc reservacion_det
		// Name             Type         Nullable Default Comments         
		// ---------------- ------------ -------- ------- ---------------- 
		// NRO_RESERVACION  CHAR(10)                      nro reservacion  
		// ORG_AMP_REF      CHAR(2)                       org amp ref      
		// NRO_AMP_REF      NUMBER(10)                    nro amp ref      
		// CANTIDAD         NUMBER(12,4) Y        0       cantidad         
		// FLAG_ESTADO      CHAR(1)      Y        '1'     flag estado      
		// FLAG_REPLICACION CHAR(1)      Y        '1'     flag_replicacion 
		
		select NVL(max(nro_item),0)
			into :ll_nro_item
			from reservacion_det
		where nro_reservacion = :is_reservacion;
		
		ll_nro_item ++
		
		insert into reservacion_det(nro_reservacion, org_amp_ref, nro_amp_ref, 
			cantidad, flag_estado, fec_registro, fec_vencimiento,
			nro_item, cod_usr)
		values(
			:is_reservacion, :ls_org_amp, :ll_nro_amp, :ldc_cantidad, '1',
			SYSDATE, SYSDATE + (select DIAS_VENC_RESERVAC from logparam where reckey = '1'),
			:ll_nro_item, :gs_user);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			SetMicroHelp('Error al insertar en Reservacion_det: ' + ls_mensaje)
			//return
		else
			ll_count2 ++
			commit;
		end if
	end if
next

hpb_1.visible = false

of_retrieve()

SetMicroHelp('Se he generado la reservacion Nro: ' + is_reservacion )
is_reservacion = ''
MessageBox('Aviso', 'Proceso realizado satisfactoriamente')



end subroutine

public subroutine of_retrieve ();string 	ls_almacen
Date		ld_fecha1, ld_fecha2

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe Elegir un almacen previamente')
		return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'
end if

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

dw_master.retrieve(ls_almacen, ld_fecha1, ld_fecha2)

end subroutine

on w_cm911_reserv_automatica.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cbx_1=create cbx_1
this.sle_reservacion=create sle_reservacion
this.st_1=create st_1
this.hpb_1=create hpb_1
this.uo_fecha=create uo_fecha
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.st_2=create st_2
this.dw_master=create dw_master
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cb_leer=create cb_leer
this.cb_selectall=create cb_selectall
this.cb_unselectall=create cb_unselectall
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.sle_reservacion
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.sle_almacen
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.cb_leer
this.Control[iCurrent+13]=this.cb_selectall
this.Control[iCurrent+14]=this.cb_unselectall
this.Control[iCurrent+15]=this.cb_4
end on

on w_cm911_reserv_automatica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.sle_reservacion)
destroy(this.st_1)
destroy(this.hpb_1)
destroy(this.uo_fecha)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.st_2)
destroy(this.dw_master)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cb_leer)
destroy(this.cb_selectall)
destroy(this.cb_unselectall)
destroy(this.cb_4)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

hpb_1.x = dw_master.x
hpb_1.width  = newwidth  - hpb_1.x - 10

end event

type cbx_1 from checkbox within w_cm911_reserv_automatica
integer x = 1934
integer y = 20
integer width = 558
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Almacenes "
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_reservacion from singlelineedit within w_cm911_reserv_automatica
integer x = 1458
integer y = 172
integer width = 530
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cm911_reserv_automatica
integer x = 18
integer y = 16
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_cm911_reserv_automatica
boolean visible = false
integer y = 344
integer width = 2153
integer height = 68
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type uo_fecha from u_ingreso_rango_fechas within w_cm911_reserv_automatica
event destroy ( )
integer x = 50
integer y = 112
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;String ls_desde

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton


end event

type sle_descrip from singlelineedit within w_cm911_reserv_automatica
integer x = 585
integer y = 4
integer width = 1330
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_cm911_reserv_automatica
event dobleclick pbm_lbuttondblclk
integer x = 338
integer y = 4
integer width = 224
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()

end event

type st_2 from statictext within w_cm911_reserv_automatica
integer x = 1467
integer y = 104
integer width = 507
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Reservacion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cm911_reserv_automatica
integer y = 420
integer width = 2199
integer height = 1488
integer taborder = 30
string dataobject = "d_cns_saldo_libre_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	// tabular, form (default)
end event

type pb_2 from picturebutton within w_cm911_reserv_automatica
integer x = 2766
integer y = 140
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type pb_1 from picturebutton within w_cm911_reserv_automatica
integer x = 2441
integer y = 140
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)
of_procesa_all( )
SetPointer(Arrow!)
end event

type cb_leer from commandbutton within w_cm911_reserv_automatica
integer x = 2130
integer y = 152
integer width = 256
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Leer"
end type

event clicked;SetPointer(HourGlass!)
//SetMicrohelp('Actualizando saldo reservado')
//of_act_saldo_reserv( )
//SetMicrohelp('saldo reservado actualizado')
of_retrieve()
SetMicrohelp('Registros Recuperados: ' + string(dw_master.RowCount()))
SetPointer(Arrow!)
end event

type cb_selectall from commandbutton within w_cm911_reserv_automatica
integer y = 248
integer width = 384
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	dw_master.object.flag_estado[ll_i] = '1'
next
end event

type cb_unselectall from commandbutton within w_cm911_reserv_automatica
integer x = 384
integer y = 248
integer width = 384
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "UnSelect All"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	dw_master.object.flag_estado[ll_i] = '0'
next
end event

type cb_4 from commandbutton within w_cm911_reserv_automatica
integer x = 773
integer y = 248
integer width = 384
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Invert Selection"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	if dw_master.object.flag_estado[ll_i] = '0' then
		dw_master.object.flag_estado[ll_i] = '1'
	else
		dw_master.object.flag_estado[ll_i] = '0'
	end if
next
end event

