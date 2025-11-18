$PBExportHeader$w_al330_parte_ingreso.srw
forward
global type w_al330_parte_ingreso from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_al330_parte_ingreso
end type
type uo_fechas from u_ingreso_rango_fechas within w_al330_parte_ingreso
end type
type gb_2 from groupbox within w_al330_parte_ingreso
end type
end forward

global type w_al330_parte_ingreso from w_abc_master_smpl
integer width = 3493
integer height = 2572
string title = "[AL330] Parte de Ingreso masivo"
string menuname = "m_mantenimiento_sl"
cb_buscar cb_buscar
uo_fechas uo_fechas
gb_2 gb_2
end type
global w_al330_parte_ingreso w_al330_parte_ingreso

on w_al330_parte_ingreso.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.gb_2
end on

on w_al330_parte_ingreso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;Date	ld_fecha1, ld_fecha2

select to_date('01' || to_char(sysdate,'mmyyyy'),'ddmmyyyy'), trunc(sysdate)
	into :ld_fecha1, :ld_Fecha2
from dual;

if SQLCA.SQLCOde = 0 then
	uo_fechas.of_set_fecha( ld_fecha1, ld_fecha2)
end if
ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_desde, ld_hasta

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_desde, ld_hasta)
end event

event ue_insert;//Override
Str_parametros		lstr_param
w_al331_parte_ingreso_masivo lw_1

lstr_param.string1 = "new"



OpenSheetWithParm (lw_1, lstr_param, w_main, 0, layered!)


end event

event ue_modify;//Override
Str_parametros		lstr_param
w_al331_parte_ingreso_masivo lw_1

if dw_master.RowCount() = 0 then return

lstr_param.string1 = "edit"
lstr_param.string2 = dw_master.object.nro_parte [dw_master.getRow()]

OpenSheetWithParm (lw_1, lstr_param, w_main, 0, layered!)

end event

event ue_anular;call super::ue_anular;Integer 	j
Long 		ll_row, ll_count
String 	ls_tipo_ref, ls_nro_ref, ls_nro_vale, ls_origen_vale
Decimal	ldc_cant_fact

IF dw_master.rowcount() = 0 then return

string ls_nro_parte
ll_row = dw_master.getrow( )

if ll_row = 0 then return 

ls_nro_parte = dw_master.object.nro_parte [ll_row]

if dw_master.object.flag_estado [ll_row]<> '1' then
	MessageBox('Aviso', 'No se puede anular este movimiento de almacen')
	return
end if

IF MessageBox("Anulacion de Registro "  ,  "Nro Parte: " + ls_nro_parte + ".  Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

string  ls_mensaje
integer li_ok

DECLARE usp_alm_act_saldo_x_art PROCEDURE FOR
	PKG_ZC_PARTE_INGRESO.of_anula_parte_ingreso(:ls_nro_parte );

EXECUTE usp_alm_act_saldo_x_art;



IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_saldo_x_art:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

FETCH usp_alm_act_saldo_x_art INTO :ls_mensaje, :li_ok;
CLOSE usp_alm_act_saldo_x_art;

if li_ok <> 1 then
 	ROLLBACK;
	MessageBox('Aviso', ls_mensaje);
	return 
end if

this.event ue_retrieve( )



end event

type dw_master from w_abc_master_smpl`dw_master within w_al330_parte_ingreso
integer y = 196
integer width = 3305
integer height = 2108
string dataobject = "d_lista_parte_ingreso_det"
end type

event dw_master::doubleclicked;call super::doubleclicked;str_parametros lstr_rep

if row = 0 then return

parent.event ue_modify( )
end event

event dw_master::constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type cb_buscar from commandbutton within w_al330_parte_ingreso
integer x = 1330
integer y = 48
integer width = 571
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_fechas from u_ingreso_rango_fechas within w_al330_parte_ingreso
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 80
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type gb_2 from groupbox within w_al330_parte_ingreso
integer width = 4320
integer height = 180
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtro para parte de Ingreso Masivo"
end type

