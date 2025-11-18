$PBExportHeader$w_ap907_anula_os.srw
forward
global type w_ap907_anula_os from w_abc
end type
type cb_1 from commandbutton within w_ap907_anula_os
end type
type dw_master from u_dw_abc within w_ap907_anula_os
end type
type st_nom_proveedor from statictext within w_ap907_anula_os
end type
type sle_proveedor from singlelineedit within w_ap907_anula_os
end type
type st_3 from statictext within w_ap907_anula_os
end type
type st_2 from statictext within w_ap907_anula_os
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap907_anula_os
end type
type pb_1 from picturebutton within w_ap907_anula_os
end type
type pb_2 from picturebutton within w_ap907_anula_os
end type
type st_1 from statictext within w_ap907_anula_os
end type
end forward

global type w_ap907_anula_os from w_abc
integer width = 3031
integer height = 1596
string title = "[AP907] Anulación de OS de Transporte"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
cb_1 cb_1
dw_master dw_master
st_nom_proveedor st_nom_proveedor
sle_proveedor sle_proveedor
st_3 st_3
st_2 st_2
uo_fechas uo_fechas
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_ap907_anula_os w_ap907_anula_os

forward prototypes
public subroutine of_retrieve ()
end prototypes

event ue_aceptar();// Para actualizar los costos de ultima compra
SetPointer (HourGlass!)
 
string 	ls_mensaje, ls_nro_os
long		ll_row, ll_count

//Verifico si ha marcado alguna OC para anular
ll_count = 0
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.flag[ll_row] = '1' then
		ll_count ++
	end if
next

if ll_count = 0 then
	MessageBox('Error', 'No ha marcado ninguna OS para anular')
	return
end if

SetPointer (HourGlass!)

// Ahora anular las OC que estan marcadas
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.flag[ll_row] = '1' then
		ls_nro_os = dw_master.object.nro_os[ll_row]
		//create or replace procedure USP_AP_ANULA_OS(
		//       asi_nro_os    IN orden_servicio.nro_os%TYPE
		//) IS
	
		DECLARE USP_AP_ANULA_OS PROCEDURE FOR
						USP_AP_ANULA_OS( :ls_nro_os );
		 
		EXECUTE USP_AP_ANULA_OS;
		 
		IF SQLCA.sqlcode = -1 THEN
			 ls_mensaje = "PROCEDURE USP_AP_ANULA_OS: " + SQLCA.SQLErrText
			 ROLLBACK ;
			 MessageBox('SQL error', ls_mensaje, StopSign!) 
			 SetPointer (Arrow!)
			 RETURN 
		END IF
				
		CLOSE USP_AP_ANULA_OS;
	end if
next

COMMIT;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
this.of_retrieve( )

SetPointer (Arrow!)


end event

event ue_salir();close(this)
end event

public subroutine of_retrieve ();date ld_fecha1, ld_fecha2
string ls_proveedor

if trim(sle_proveedor.text) = '' then
	ls_proveedor = '%%'
else
	ls_proveedor = trim(sle_proveedor.text) + '%'
end if

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

dw_master.setTRansobject( SQLCA )
dw_master.retrieve(ls_proveedor, ld_fecha1, ld_Fecha2 )
end subroutine

on w_ap907_anula_os.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_1=create cb_1
this.dw_master=create dw_master
this.st_nom_proveedor=create st_nom_proveedor
this.sle_proveedor=create sle_proveedor
this.st_3=create st_3
this.st_2=create st_2
this.uo_fechas=create uo_fechas
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.st_nom_proveedor
this.Control[iCurrent+4]=this.sle_proveedor
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.uo_fechas
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.st_1
end on

on w_ap907_anula_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.st_nom_proveedor)
destroy(this.sle_proveedor)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.uo_fechas)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

type cb_1 from commandbutton within w_ap907_anula_os
integer x = 2043
integer y = 176
integer width = 466
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.of_retrieve()
end event

type dw_master from u_dw_abc within w_ap907_anula_os
integer y = 436
integer width = 3003
integer height = 792
integer taborder = 60
string dataobject = "d_list_os_ap_pd_tbl"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type st_nom_proveedor from statictext within w_ap907_anula_os
integer x = 814
integer y = 312
integer width = 2181
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_proveedor from singlelineedit within w_ap907_anula_os
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 312
integer width = 352
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )


ls_sql = "SELECT distinct p.proveedor as codigo_proveedor, " &
		 + "p.nom_proveedor as nombre_proveedor, " &
		 + "p.ruc as ruc_proveedor " &
		 + "FROM ap_pd_descarga_det a, " &
		 + "proveedor p, " &
		 + "orden_servicio os " &
		 + "WHERE p.proveedor = a.prov_transporte " &
		 + " and a.nro_os = os.nro_os " &
		 + " and os.monto_facturado = 0 " &
		 + " and to_char(a.inicio_descarga, 'yyyymmdd') between " &
		 + string(ld_Fecha1, 'yyyymmdd') + " and " + string(ld_fecha2, 'yyyymmdd')

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_nom_proveedor.text = ls_data
end if

end event

type st_3 from statictext within w_ap907_anula_os
integer x = 32
integer y = 320
integer width = 370
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap907_anula_os
integer x = 50
integer y = 176
integer width = 498
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_ap907_anula_os
integer x = 562
integer y = 172
integer taborder = 40
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type pb_1 from picturebutton within w_ap907_anula_os
integer x = 818
integer y = 1240
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_ap907_anula_os
integer x = 1829
integer y = 1240
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_ap907_anula_os
integer x = 55
integer y = 40
integer width = 2624
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Anular Ordenes de Servicios en un periodo"
alignment alignment = center!
boolean focusrectangle = false
end type

