$PBExportHeader$w_cn009_tipo_cambio.srw
forward
global type w_cn009_tipo_cambio from w_abc_master
end type
type uo_1 from u_ingreso_fecha within w_cn009_tipo_cambio
end type
end forward

global type w_cn009_tipo_cambio from w_abc_master
integer width = 1865
integer height = 1548
string title = "Tipo de cambio (CN009)"
string menuname = "m_mantto_smpl"
uo_1 uo_1
end type
global w_cn009_tipo_cambio w_cn009_tipo_cambio

type variables
Decimal {3} id_vta_dol_prom, id_cmp_dol_prom

end variables

on w_cn009_tipo_cambio.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_cn009_tipo_cambio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
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

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50) 
Date ld_fecha
ld_fecha = DATE( today() )
dw_master.retrieve(ld_fecha)

end event

event ue_insert_pos;call super::ue_insert_pos;Date ld_fecha
Long	ll_rc
Integer	li_mes, li_dia
String	ls_flag, ls_flag_laborable

ld_fecha = uo_1.of_get_fecha()

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

ld_fecha = uo_1.of_get_fecha()

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

uo_1.of_set_fecha(ld_fecha)
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
integer x = 18
integer y = 212
integer width = 1774
integer height = 1120
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

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type uo_1 from u_ingreso_fecha within w_cn009_tipo_cambio
integer x = 41
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

event ue_output;call super::ue_output;Date ld_fecha
Long	ll_rc
Integer li_msg_result

ld_fecha = THIS.of_get_fecha()
ll_rc = dw_master.retrieve(ld_fecha)

IF ll_rc = 0 THEN
	li_msg_result = MessageBox('No existe Registro', 'Desea Crear una Nueva Fecha', Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		PARENT.EVENT ue_insert()
	END IF
END IF
end event

