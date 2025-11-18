$PBExportHeader$w_al313_consig_liq.srw
forward
global type w_al313_consig_liq from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_al313_consig_liq
end type
type st_1 from statictext within w_al313_consig_liq
end type
type st_2 from statictext within w_al313_consig_liq
end type
type sle_alm from singlelineedit within w_al313_consig_liq
end type
type sle_prov from singlelineedit within w_al313_consig_liq
end type
type cb_alm from commandbutton within w_al313_consig_liq
end type
type cb_prov from commandbutton within w_al313_consig_liq
end type
type st_desc_alm from statictext within w_al313_consig_liq
end type
type st_desc_prov from statictext within w_al313_consig_liq
end type
type cb_2 from commandbutton within w_al313_consig_liq
end type
type st_5 from statictext within w_al313_consig_liq
end type
type sle_mon from singlelineedit within w_al313_consig_liq
end type
type cb_moneda from commandbutton within w_al313_consig_liq
end type
type st_desc_mon from statictext within w_al313_consig_liq
end type
type st_3 from statictext within w_al313_consig_liq
end type
type sle_forma_pago from singlelineedit within w_al313_consig_liq
end type
type cb_3 from commandbutton within w_al313_consig_liq
end type
type st_forma_pago from statictext within w_al313_consig_liq
end type
type gb_1 from groupbox within w_al313_consig_liq
end type
end forward

global type w_al313_consig_liq from w_abc_master_smpl
integer width = 2693
integer height = 1812
string title = "Liquidacion de consignaciones [AL313]"
string menuname = "m_only_grabar"
event ue_generar_oc ( )
cb_1 cb_1
st_1 st_1
st_2 st_2
sle_alm sle_alm
sle_prov sle_prov
cb_alm cb_alm
cb_prov cb_prov
st_desc_alm st_desc_alm
st_desc_prov st_desc_prov
cb_2 cb_2
st_5 st_5
sle_mon sle_mon
cb_moneda cb_moneda
st_desc_mon st_desc_mon
st_3 st_3
sle_forma_pago sle_forma_pago
cb_3 cb_3
st_forma_pago st_forma_pago
gb_1 gb_1
end type
global w_al313_consig_liq w_al313_consig_liq

type variables
Integer ii_prov, ii_alm

end variables

event ue_generar_oc();// Genera orden de compra
string 	ls_forma_pago, ls_msg, ls_proveedor
integer	li_ok
Date 		ld_fecha

ls_forma_pago 	= trim(sle_forma_pago.text)

if ls_forma_pago = '' or IsNull(ls_forma_pago) then
	MessageBox('Aviso', 'Debe Ingresar una forma de pago')
	sle_forma_pago.SetFocus()
	return
end if

ld_fecha 		= Today()
ls_proveedor	= sle_prov.text

if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe Ingresar un Proveedor')
	sle_prov.SetFocus()
	return
end if

//create or replace procedure USP_ALM_GENERAR_OC(
//     asi_origen         in  origen.cod_origen%TYPE,
//     asi_forma_pago     in  forma_pago.forma_pago%TYPE,
//     asi_proveedor      in  proveedor.proveedor%TYPE,
//     adi_fecha          in  date,
//     asi_user           in  usuario.cod_usr%TYPE,
//     aso_mensaje        out varchar2,
//     aio_ok 			      out number
//) is

DECLARE USP_ALM_GENERAR_OC PROCEDURE FOR 
	USP_ALM_GENERAR_OC(:gs_origen, 
							 :ls_forma_pago,
							 :ls_proveedor,
							 :ld_fecha,
							 :gs_user	);
	
EXECUTE USP_ALM_GENERAR_OC;

if sqlca.sqlcode = -1 then   // Fallo
	ls_msg = sqlca.sqlerrtext
	rollback;
	MessageBox( 'Error USP_ALM_GENERAR_OC', ls_msg, StopSign! )
	return 
End If
	
Fetch USP_ALM_GENERAR_OC into :ls_msg, :li_ok;	
close USP_ALM_GENERAR_OC;

// Activa boton de orden compra
if li_ok = 0 then
	MessageBox('Error USP_ALM_GENERAR_OC', ls_msg)
	return
end if

MessageBox('Aviso', 'Procedimiento ejecutado Satisfactoriamente', Exclamation!)
dw_master.Retrieve()

end event

on w_al313_consig_liq.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_alm=create sle_alm
this.sle_prov=create sle_prov
this.cb_alm=create cb_alm
this.cb_prov=create cb_prov
this.st_desc_alm=create st_desc_alm
this.st_desc_prov=create st_desc_prov
this.cb_2=create cb_2
this.st_5=create st_5
this.sle_mon=create sle_mon
this.cb_moneda=create cb_moneda
this.st_desc_mon=create st_desc_mon
this.st_3=create st_3
this.sle_forma_pago=create sle_forma_pago
this.cb_3=create cb_3
this.st_forma_pago=create st_forma_pago
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_alm
this.Control[iCurrent+5]=this.sle_prov
this.Control[iCurrent+6]=this.cb_alm
this.Control[iCurrent+7]=this.cb_prov
this.Control[iCurrent+8]=this.st_desc_alm
this.Control[iCurrent+9]=this.st_desc_prov
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.sle_mon
this.Control[iCurrent+13]=this.cb_moneda
this.Control[iCurrent+14]=this.st_desc_mon
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.sle_forma_pago
this.Control[iCurrent+17]=this.cb_3
this.Control[iCurrent+18]=this.st_forma_pago
this.Control[iCurrent+19]=this.gb_1
end on

on w_al313_consig_liq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_alm)
destroy(this.sle_prov)
destroy(this.cb_alm)
destroy(this.cb_prov)
destroy(this.st_desc_alm)
destroy(this.st_desc_prov)
destroy(this.cb_2)
destroy(this.st_5)
destroy(this.sle_mon)
destroy(this.cb_moneda)
destroy(this.st_desc_mon)
destroy(this.st_3)
destroy(this.sle_forma_pago)
destroy(this.cb_3)
destroy(this.st_forma_pago)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//of_center_window()

end event

type dw_master from w_abc_master_smpl`dw_master within w_al313_consig_liq
integer x = 0
integer y = 452
integer height = 1048
string dataobject = "d_list_liq_consignacion"
end type

event dw_master::constructor;call super::constructor;ii_lec_mst = 0
end event

type cb_1 from commandbutton within w_al313_consig_liq
integer x = 1970
integer y = 188
integer width = 494
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera O/Compra"
end type

event clicked;parent.event dynamic ue_generar_oc()
end event

type st_1 from statictext within w_al313_consig_liq
integer x = 32
integer y = 76
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al313_consig_liq
integer x = 32
integer y = 168
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
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

type sle_alm from singlelineedit within w_al313_consig_liq
integer x = 334
integer y = 68
integer width = 325
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//// Verifica que el almacen exista
//String ls_alm
//Long ll_count
//
//ls_alm = sle_alm.text
//
//Select count(*) into :ll_count from almacen where almacen = :ls_alm;
//if ll_count = 0 then
//	Messagebox( "Error", "Codigo de almacen no existe")
//	return
//end if
end event

event losefocus;// Verifica que el almacen exista
String ls_alm
Long ll_count

ls_alm = sle_alm.text

if TRIM( ls_alm ) <> '' then
	Select count(*) into :ll_count from almacen where almacen = :ls_alm;
	if ll_count = 0 then
		Messagebox( "Error", "Codigo de almacen no existe")
		sle_alm.text = ''
		sle_alm.SetFocus()
		return 
	end if
end if
end event

type sle_prov from singlelineedit within w_al313_consig_liq
integer x = 334
integer y = 160
integer width = 325
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que el proveedor exista
String ls_prov
Long ll_count

ls_prov = sle_prov.text

if TRIM( ls_prov ) <> '' then
	Select count(*) 
		into :ll_count 
	from proveedor 
	where proveedor = :ls_prov;
	
	if ll_count = 0 then
		Messagebox( "Error", "Codigo de proveedor no existe")
		sle_prov.text = ''
		sle_prov.SetFocus()
		return 
	end if
end if
end event

type cb_alm from commandbutton within w_al313_consig_liq
integer x = 667
integer y = 68
integer width = 87
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_almacen, ls_data
boolean lb_ret

ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
		  + "DESC_ALMACEN AS DESCRIPCION_ALMACEN " &
		  + "FROM ALMACEN " 
			 
lb_ret = f_lista(ls_sql, ls_almacen, &
			ls_data, '1')
	
if ls_almacen <> '' then
	sle_alm.text		= ls_almacen
	st_desc_alm.text 	= ls_data
end if

end event

type cb_prov from commandbutton within w_al313_consig_liq
integer x = 667
integer y = 160
integer width = 87
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_almacen, ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_almacen = sle_alm.text

ls_sql = "select distinct p.proveedor as codigo_relacion, " &
		 + "p.nom_proveedor as nombre_o_razon_social, " &
		 + "p.RUC as RUC_proveedor " &
		 + "from proveedor p, " &
		 + "articulo_consignacion ac " &
		 + "where p.proveedor = ac.proveedor " &
		 + "and ac.almacen = '" + ls_almacen + "' " &
		 + "and ac.flag_estado = '1' " &
		 + "order by p.proveedor"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_prov.text 		= ls_codigo
	st_desc_prov.text = ls_data
end if
end event

type st_desc_alm from statictext within w_al313_consig_liq
integer x = 763
integer y = 68
integer width = 1161
integer height = 80
boolean bringtotop = true
integer textsize = -8
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

type st_desc_prov from statictext within w_al313_consig_liq
integer x = 763
integer y = 160
integer width = 1161
integer height = 80
boolean bringtotop = true
integer textsize = -8
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

type cb_2 from commandbutton within w_al313_consig_liq
integer x = 1970
integer y = 56
integer width = 494
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar Mov."
end type

event clicked;String ls_prov, ls_alm, ls_msg, ls_mon
Integer li_ok

ls_alm 	= sle_alm.text
ls_prov 	= sle_prov.text
ls_mon 	= sle_mon.text
li_ok = 0
cb_1.enabled = false

if TRIM( ls_alm ) = '' then
	Messagebox( "Atencion", "Ingrese el almacen")
	sle_alm.SetFocus()
	return
end if

if TRIM( ls_prov ) = '' then
	Messagebox( "Atencion", "Ingrese el Proveedor")
	sle_prov.SetFocus()
	return
end if

if TRIM( ls_mon ) = '' then
	Messagebox( "Atencion", "Ingrese moneda")
	sle_mon.SetFocus()
	return
end if

SetPointer( Hourglass!)

//create or replace procedure USP_ALM_LIQ_CONSIG_V2(
//     asi_proveedor      in  PROVEEDOR.PROVEEDOR%TYPE, 
//     asi_almacen        in  almacen.almacen%TYPE, 
//     asi_moneda         in  moneda.cod_moneda%TYPE, 
//     aso_mensaje        out varchar2,
//     aio_ok 			     out number) is

DECLARE USP_ALM_LIQ_CONSIG_V2 PROCEDURE FOR 
	USP_ALM_LIQ_CONSIG_V2(:ls_prov, :ls_alm, :ls_mon);
	
EXECUTE USP_ALM_LIQ_CONSIG_V2;
if sqlca.sqlcode = -1 then   // Fallo
	ls_msg = sqlca.sqlerrtext
	rollback;
	MessageBox( 'Error USP_ALM_LIQ_CONSIG_V2', ls_msg, StopSign! )
	return 0
End If
	
Fetch USP_ALM_LIQ_CONSIG_V2 into :ls_msg, :li_ok;	
close USP_ALM_LIQ_CONSIG_V2;

// Activa boton de orden compra
if li_ok = 0 then
	cb_1.enabled = false
	sle_forma_pago.enabled = false
	MessageBox('Error USP_ALM_LIQ_CONSIG_V2', ls_msg)
	dw_master.Reset()
	return
end if

dw_master.retrieve()

if dw_master.RowCount() =  0 then
	cb_1.enabled = false
	sle_forma_pago.enabled = false
else
	cb_1.enabled = true
	sle_forma_pago.enabled = true
end if
end event

type st_5 from statictext within w_al313_consig_liq
integer x = 32
integer y = 260
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mon from singlelineedit within w_al313_consig_liq
integer x = 334
integer y = 252
integer width = 325
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que la moneda exista
String ls_mon
Long ll_count

ls_mon = sle_mon.text

if TRIM( ls_mon ) <> '' then
	Select count(*) into :ll_count from moneda where cod_moneda = :ls_mon;
	if ll_count = 0 then
		Messagebox( "Error", "Moneda no existe")
		sle_mon.text = ''
		sle_mon.SetFocus()
		return 
	end if
end if
end event

type cb_moneda from commandbutton within w_al313_consig_liq
integer x = 667
integer y = 252
integer width = 87
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_almacen, ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_almacen = sle_alm.text


ls_sql = "select a.cod_moneda as codigo_moneda, " &
		 + "a.descripcion as descripcion_moneda " &
		 + "from moneda a " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_mon.text 		= ls_codigo
	st_desc_mon.text = ls_data
end if

end event

type st_desc_mon from statictext within w_al313_consig_liq
integer x = 763
integer y = 252
integer width = 1161
integer height = 80
boolean bringtotop = true
integer textsize = -8
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

type st_3 from statictext within w_al313_consig_liq
integer x = 18
integer y = 352
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Foma Pago:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_forma_pago from singlelineedit within w_al313_consig_liq
integer x = 334
integer y = 344
integer width = 325
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que la moneda exista
String ls_mon
Long ll_count

ls_mon = sle_mon.text

if TRIM( ls_mon ) <> '' then
	Select count(*) into :ll_count from moneda where cod_moneda = :ls_mon;
	if ll_count = 0 then
		Messagebox( "Error", "Moneda no existe")
		sle_mon.text = ''
		sle_mon.SetFocus()
		return 
	end if
end if
end event

type cb_3 from commandbutton within w_al313_consig_liq
integer x = 667
integer y = 344
integer width = 87
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_almacen, ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_almacen = sle_alm.text

ls_sql = "select forma_pago as forma_pago, " &
		 + "desc_forma_pago as descripcion_forma_pago " &
		 + "from forma_pago " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_forma_pago.text 	= ls_codigo
	st_forma_pago.text 	= ls_data
end if

end event

type st_forma_pago from statictext within w_al313_consig_liq
integer x = 763
integer y = 344
integer width = 1161
integer height = 80
boolean bringtotop = true
integer textsize = -8
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

type gb_1 from groupbox within w_al313_consig_liq
integer width = 1943
integer height = 440
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

