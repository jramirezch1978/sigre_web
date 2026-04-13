$PBExportHeader$w_cn009_tipo_cambio.srw
forward
global type w_cn009_tipo_cambio from w_abc_master
end type
type uo_fecha from u_ingreso_fecha within w_cn009_tipo_cambio
end type
type shl_1 from statichyperlink within w_cn009_tipo_cambio
end type
type cb_1 from commandbutton within w_cn009_tipo_cambio
end type
type cb_sunat from commandbutton within w_cn009_tipo_cambio
end type
end forward

global type w_cn009_tipo_cambio from w_abc_master
integer width = 1879
integer height = 1296
string title = "Tipo de cambio (CN009)"
string menuname = "m_abc_master_smpl"
event ue_buscar ( )
uo_fecha uo_fecha
shl_1 shl_1
cb_1 cb_1
cb_sunat cb_sunat
end type
global w_cn009_tipo_cambio w_cn009_tipo_cambio

type variables
Decimal {3} id_vta_dol_prom, id_cmp_dol_prom

end variables

event ue_buscar();Date ld_fecha
Long	ll_rc
Integer li_msg_result

ld_fecha = uo_fecha.of_get_fecha()
ll_rc = dw_master.retrieve(ld_fecha)

IF ll_rc = 0 THEN
	li_msg_result = MessageBox('No existe Registro', 'Desea Crear una Nueva Fecha', Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.EVENT ue_insert()
	END IF
END IF
end event

on w_cn009_tipo_cambio.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_fecha=create uo_fecha
this.shl_1=create shl_1
this.cb_1=create cb_1
this.cb_sunat=create cb_sunat
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_sunat
end on

on w_cn009_tipo_cambio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.shl_1)
destroy(this.cb_1)
destroy(this.cb_sunat)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("fecha.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("fecha")
END IF

end event

event ue_update_pre;call super::ue_update_pre;//ld_fecha = DATE(dw_master.GetItemDateTime(dw_master.GetRow(), 'fecha'))
//
//SELECT count(*) 
//  INTO :ll_count 
//  FROM calendario 
// WHERE trunc(fecha)=:ld_fecha ;
//
//IF ll_count>0 THEN
//	messagebox('Aviso', 'Fecha duplicada')
//END IF
//// Asignando el trunc a la fecha (sin horas)
//dw_master.SetItem(dw_master.GetRow(), 'fecha', ld_fecha)

dw_master.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;Date ld_fecha
ld_fecha = DATE( gnvo_app.of_fecha_actual() )
dw_master.retrieve(ld_fecha)

end event

event ue_insert_pos;call super::ue_insert_pos;Date ld_fecha
Long	ll_rc
Integer	li_mes, li_dia
String	ls_flag, ls_flag_laborable

ld_fecha = uo_fecha.of_get_fecha()

ll_rc = dw_master.SetItem(al_row, 'fecha', ld_fecha)

// Determinar Dia Laborable
li_mes = Month(ld_fecha)
li_dia = Day(ld_fecha)

SELECT "CALENDARIO_FERIADO"."FLAG_MEDIO_DIA_LAB"  
  INTO :ls_flag  
  FROM "CALENDARIO_FERIADO"  
 WHERE ( "CALENDARIO_FERIADO"."MES" = :li_mes ) AND  
       ( "CALENDARIO_FERIADO"."DIA" = :li_dia )   ;
		 
IF SQLCA.SQLCODE = 0 THEN
	IF ls_flag = '1' THEN
		ls_flag_laborable = 'M'
	ELSE
		ls_flag_laborable = 'N'
	END IF
ELSE
	IF DayNumber(ld_fecha) = 1 THEN // CUANDO ES DOMINGO
		ls_flag_laborable = 'N'
	ELSE
		ls_flag_laborable = 'L'
	END IF
END IF

ll_rc = dw_master.SetItem(al_row, 'flag_laborable', ls_flag_laborable)


end event

event ue_scrollrow;// override
Date ld_fecha
Long	ll_rc
Integer li_msg_result, li_ano, li_mes
String	ls_fecha

ld_fecha = uo_fecha.of_get_fecha()

CHOOSE CASE as_value
	CASE 'F'
		li_ano = Year(ld_fecha)
		li_mes = Month(ld_fecha)
		ls_fecha = String(li_ano)+'/'+String(li_mes)+'/1'
		ld_fecha = Date(ls_fecha)
	CASE 'P'
		ld_fecha = RelativeDate(ld_fecha,-1)
	CASE 'N'
		ld_fecha = RelativeDate(ld_fecha,1)
	CASE 'L'
		li_ano = Year(ld_fecha)
		li_mes = Month(ld_fecha) + 1
		IF li_mes = 13 THEN
			li_mes = 1
			li_ano = li_ano + 1
		END IF
		ls_fecha = String(li_ano)+'/'+String(li_mes)+'/1'
		ld_fecha = RelativeDate(Date(ls_fecha),-1)
END CHOOSE

uo_fecha.of_set_fecha(ld_fecha)
ll_rc = dw_master.retrieve(ld_fecha)

IF ll_rc = 0 THEN
	li_msg_result = MessageBox('No existe Registro', 'Desea Crear una Nueva Fecha', Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_insert()
	END IF
END IF


RETURN 0
end event

type dw_master from w_abc_master`dw_master within w_cn009_tipo_cambio
integer y = 208
integer width = 1829
integer height = 880
string dataobject = "d_calendario_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::doubleclicked;call super::doubleclicked;Datawindow ldw
ldw = This
if dwo.type<>'column' Then RETURN 1
CHOOSE CASE dwo.name
	    CASE 'fecha'
			f_call_calendar(ldw,'fecha',dwo.coltype,row)
END CHOOSE			
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.SetItem(al_row, 'fecha', gd_fecha)

select vta_dol_prom, cmp_dol_prom 
  into :id_vta_dol_prom, :id_cmp_dol_prom
from calendario where fecha in (select max(fecha) from calendario) ;

this.object.cmp_dol_prom[al_row] = id_cmp_dol_prom
this.object.vta_dol_prom[al_row] = id_vta_dol_prom
this.object.cod_usr		[al_row] = gs_user

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type uo_fecha from u_ingreso_fecha within w_cn009_tipo_cambio
integer x = 32
integer y = 16
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type shl_1 from statichyperlink within w_cn009_tipo_cambio
integer x = 27
integer y = 124
integer width = 727
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "Tipo de Cambio SUNAT"
boolean focusrectangle = false
string url = "http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias"
end type

type cb_1 from commandbutton within w_cn009_tipo_cambio
integer x = 718
integer y = 12
integer width = 352
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_buscar()
end event

type cb_sunat from commandbutton within w_cn009_tipo_cambio
integer x = 1092
integer y = 12
integer width = 448
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "TC SUNAT"
end type

event cb_sunat::clicked;Date ld_fecha
Long ll_row
String ls_fecha_str, ls_json, ls_compra, ls_venta
Decimal {3} ldc_compra, ldc_venta
n_cst_api_sigre_dll lnvo_dll
n_cst_utilitario lnvo_util

ll_row = dw_master.GetRow()
if ll_row <= 0 then
	MessageBox('Aviso', 'No hay registro seleccionado', Information!)
	return
end if

ld_fecha = dw_master.GetItemDate(ll_row, 'fecha')
ls_fecha_str = String(ld_fecha, 'dd/mm/yyyy')

try
	lnvo_dll = create n_cst_api_sigre_dll

	ls_json = lnvo_dll.ObtenerTipoCambio(ls_fecha_str)

	if Pos(ls_json, '"success":true') > 0 then
		ls_compra = lnvo_util.of_json_string(ls_json, 'compra')
		ls_venta  = lnvo_util.of_json_string(ls_json, 'venta')

		ldc_compra = Decimal(ls_compra)
		ldc_venta  = Decimal(ls_venta)

		dw_master.object.cmp_dol_prom[ll_row] = ldc_compra
		dw_master.object.vta_dol_prom[ll_row] = ldc_venta
		dw_master.object.cod_usr[ll_row] = gs_user

		MessageBox('Tipo de Cambio SUNAT', 'Fecha: ' + ls_fecha_str &
			+ '~r~nCompra: ' + ls_compra &
			+ '~r~nVenta: ' + ls_venta, Information!)
	else
		ls_venta = lnvo_util.of_json_string(ls_json, 'mensaje')
		if trim(ls_venta) = '' then ls_venta = ls_json
		MessageBox('Error', 'No se pudo obtener el tipo de cambio.~r~n' + ls_venta, StopSign!)
	end if

catch (Exception ex)
	MessageBox('Error', 'Exception: ' + ex.getMessage(), StopSign!)

finally
	destroy lnvo_dll

end try

end event

