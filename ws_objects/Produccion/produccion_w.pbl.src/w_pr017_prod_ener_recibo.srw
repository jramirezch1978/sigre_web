$PBExportHeader$w_pr017_prod_ener_recibo.srw
forward
global type w_pr017_prod_ener_recibo from w_abc_master_smpl
end type
type dw_pd_ot from u_dw_abc within w_pr017_prod_ener_recibo
end type
type cb_1 from commandbutton within w_pr017_prod_ener_recibo
end type
type st_1 from statictext within w_pr017_prod_ener_recibo
end type
type em_ot_adm from singlelineedit within w_pr017_prod_ener_recibo
end type
type cb_2 from commandbutton within w_pr017_prod_ener_recibo
end type
type sle_diferencia from editmask within w_pr017_prod_ener_recibo
end type
type st_3 from statictext within w_pr017_prod_ener_recibo
end type
type em_congelado from editmask within w_pr017_prod_ener_recibo
end type
type st_4 from statictext within w_pr017_prod_ener_recibo
end type
type em_harina from editmask within w_pr017_prod_ener_recibo
end type
type st_2 from statictext within w_pr017_prod_ener_recibo
end type
type gb_1 from groupbox within w_pr017_prod_ener_recibo
end type
type ln_1 from line within w_pr017_prod_ener_recibo
end type
type ln_2 from line within w_pr017_prod_ener_recibo
end type
end forward

global type w_pr017_prod_ener_recibo from w_abc_master_smpl
integer width = 2894
integer height = 2120
string title = "Ingreso de Recibos de Energía(PR017)"
string menuname = "m_mantto_consulta"
event ue_query_retrieve_consumo ( )
event ue_aceptar ( )
dw_pd_ot dw_pd_ot
cb_1 cb_1
st_1 st_1
em_ot_adm em_ot_adm
cb_2 cb_2
sle_diferencia sle_diferencia
st_3 st_3
em_congelado em_congelado
st_4 st_4
em_harina em_harina
st_2 st_2
gb_1 gb_1
ln_1 ln_1
ln_2 ln_2
end type
global w_pr017_prod_ener_recibo w_pr017_prod_ener_recibo

event ue_query_retrieve_consumo();String 	ls_ot_adm

ls_ot_adm	=	em_ot_adm.text

dw_pd_ot.retrieve(ls_ot_adm)

dw_master.retrieve( ls_ot_adm)


//if dw_pd_ot.retrieve(ls_ot_adm)  >= 1 then
//	
//	dw_master.reset()
//else
//	dw_pd_ot.reset()
//	dw_master.reset()
//end if
end event

event ue_aceptar();dec 		ldc_monto_aprox, ldc_monto_recibo, ldc_diferencia
string 	ls_nro_consumo, ls_mensaje

ls_nro_consumo			= dw_pd_ot.object.nro_consumo[dw_pd_ot.GetRow()]
ldc_diferencia			= dec(sle_diferencia.text)

if IsNull(ls_nro_consumo) then
	MessageBox('Produccion', 'NO HA INGRESO UN Nro. De Consumo',StopSign!)
	return
end if

if ldc_monto_aprox < 0 then
	MessageBox('Produccion', 'NO HA INGRESO MONTO',StopSign!)
	return
end if

if ldc_monto_recibo < 0 then
	MessageBox('Produccion', 'NO HA INGRESO MONTO DEL RECIBO',StopSign!)
	return
end if

DECLARE USP_PROD_PRORRATEA_AJUSTE PROCEDURE FOR
	     USP_PROD_PRORRATEA_AJUSTE( :ls_nro_consumo, 
											  :ldc_diferencia);

EXECUTE USP_PROD_PRORRATEA_AJUSTE;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PROD_PRORRATEA_AJUSTE: " + SQLCA.SQLErrText
	Rollback ;
	return
END IF

CLOSE USP_PROD_PRORRATEA_AJUSTE;

MessageBox('COMEDORES', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Information!)
return
end event

on w_pr017_prod_ener_recibo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.dw_pd_ot=create dw_pd_ot
this.cb_1=create cb_1
this.st_1=create st_1
this.em_ot_adm=create em_ot_adm
this.cb_2=create cb_2
this.sle_diferencia=create sle_diferencia
this.st_3=create st_3
this.em_congelado=create em_congelado
this.st_4=create st_4
this.em_harina=create em_harina
this.st_2=create st_2
this.gb_1=create gb_1
this.ln_1=create ln_1
this.ln_2=create ln_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pd_ot
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_ot_adm
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.sle_diferencia
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.em_congelado
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_harina
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.ln_1
this.Control[iCurrent+14]=this.ln_2
end on

on w_pr017_prod_ener_recibo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_pd_ot)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_ot_adm)
destroy(this.cb_2)
destroy(this.sle_diferencia)
destroy(this.st_3)
destroy(this.em_congelado)
destroy(this.st_4)
destroy(this.em_harina)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event ue_open_pre;call super::ue_open_pre;//Override
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

dw_pd_ot.SetTransObject(SQLCA)

ib_log = TRUE
//is_tabla = 'PROD_ENER_RECIBO'
end event

event ue_query_retrieve;call super::ue_query_retrieve;//String 	ls_ot_adm
//
//ls_ot_adm	=	em_ot_adm.text
//
//dw_pd_ot.retrieve(ls_ot_adm)
//
//
////if dw_pd_ot.retrieve(ls_ot_adm)  >= 1 then
////	
////	dw_master.reset()
////else
////	dw_pd_ot.reset()
////	dw_master.reset()
////end if
end event

event resize;//Override

dw_master.width  = newwidth  - dw_master.x - 10
dw_pd_ot.width  = newwidth  - dw_pd_ot.x - 10

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr017_prod_ener_recibo
integer x = 23
integer y = 392
integer width = 2743
integer height = 1292
string dataobject = "d_abc_prod_ener_recibo_ff"
end type

event dw_master::keydwn;call super::keydwn;long ll_row, ll_total

ll_row = this.getrow()
ll_total = this.rowcount()

if keydown(KeyDownArrow!) = true then
	
	if ll_row = ll_total then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row + 1, true)
	
end if

if keydown(KeyUpArrow!) = true then
	
	if ll_row = 1 then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row - 1, true)
	
end if
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                      //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)
ii_ck[1] = 1		  // columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_consumo

long ll_count 

ll_count = dw_pd_ot.rowcount( )

if ll_count = 0 or isnull(ll_count) then
	
	messagebox('Ingreso de Energía','Primero debe de Buscar el Consumo al cual va a refernciar el Recibo')
	
	idw_1.of_protect( )
	idw_1.reset( )
	
Return 

end if


ls_consumo = dw_pd_ot.object.nro_consumo[al_row]
dw_master.object.nro_consumo [GetRow()] = ls_consumo
	
this.object.CARGO_FIJO      [al_row] = 0
this.object.CARGO_POR_REP   [al_row] = 0
this.object.AJUSTE_TARIFA   [al_row] = 0
this.object.ALUMBRADO_PUB   [al_row] = 0
this.object.INTERES_CONV    [al_row] = 0
this.object.INTERES_COMP    [al_row] = 0
this.object.CORTE_RECON     [al_row] = 0
this.object.EQUIPOS_MATERIA [al_row] = 0
this.object.INTERES_MORA    [al_row] = 0
this.object.SALDO_REDONDEO  [al_row] = 0
this.object.REDONDEO        [al_row] = 0       
this.object.IMPORTE_TOTAL   [al_row] = 0

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::buttonclicked;call super::buttonclicked;dec 		ldc_monto_aprox    , ldc_monto_recibo, ldc_monto_ajuste,&
			ldc_monto_congelado, ldc_importe_total_real, ldc_importe_total_sc
string 	ls_nro_consumo, ls_mensaje

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "b_calcular"

	ls_nro_consumo			= dw_pd_ot.object.nro_consumo[dw_pd_ot.GetRow()]
	ldc_monto_aprox 		= dw_pd_ot.object.imp_total_aprox[dw_pd_ot.GetRow()]


		
		this.object.IMPORTE_TOTAL [row] = (this.object.cargo_fijo 	[row] + &
													 this.object.cargo_por_rep [row] + &
													 this.object.ajuste_tarifa [row] + &
													 this.object.alumbrado_pub [row] + &
													 this.object.interes_conv  [row] + &
													 this.object.interes_comp 	[row] + &
													 ldc_monto_aprox)	- ( this.object.corte_recon [row] + &
													 this.object.equipos_materia 	[row] + &
													 this.object.interes_mora 		[row] + &
													 this.object.saldo_redondeo 	[row] + &
													 this.object.redondeo 			[row] )
													 
		  
		select sum(mnt_calculado)
		  into :ldc_monto_congelado
		  from prod_ener_distribucion
		 where nro_consumo = :ls_nro_consumo;
		 
		 em_congelado.text = string(ldc_monto_congelado)
		 
		 ldc_importe_total_sc = this.object.IMPORTE_TOTAL [row] - ldc_monto_congelado
		 
		 em_harina.text		 = string(ldc_importe_total_sc)
		 	 		 
   	 sle_diferencia.text = string(ldc_monto_aprox - ldc_importe_total_sc)
				
end choose

end event

type dw_pd_ot from u_dw_abc within w_pr017_prod_ener_recibo
integer x = 581
integer y = 84
integer width = 2181
integer height = 236
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_prod_ener_recibo_tbl"
boolean livescroll = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;//dw_detail.reset()
//dw_master.reset()
//
//if currentrow >= 1 then
//	if dw_master.retrieve(this.object.nro_parte[currentrow]) >= 1 then
//		dw_master.scrolltorow(1)
//		dw_master.setrow(1)
//		dw_master.selectrow( 1, true)
//	end if
//end if
end event

event ue_output;call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)
//
//dw_master.ScrollToRow(al_row)
//
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//dw_master.retrieve(aa_id[1])
end event

event ue_insert_pre;//Override
long ll_count 

ll_count = dw_master.rowcount( )

if ll_count < 0 then
	
	messagebox('Ingreso de Energía','Primero debe de Buscar el Consumo al cual va a refernciar el Recibo')

Return

end if
end event

event ue_insert;//Override 
Return 1
end event

type cb_1 from commandbutton within w_pr017_prod_ener_recibo
integer x = 114
integer y = 240
integer width = 343
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_query_retrieve_consumo()
SetPointer(Arrow!)
end event

type st_1 from statictext within w_pr017_prod_ener_recibo
integer x = 46
integer y = 72
integer width = 503
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. Consumo"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ot_adm from singlelineedit within w_pr017_prod_ener_recibo
event dobleclick pbm_lbuttondblclk
integer x = 123
integer y = 144
integer width = 329
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT TO_CHAR(PC.NRO_CONSUMO) AS NRO_CONSUMO, TO_CHAR(PC.MES) AS MES, PC.COD_PLANTA, P.DESC_PLANTA, PC.COD_ORIGEN, PC.COD_USR " &
				  + "FROM PROD_CONSUMO_ENER PC, TG_PLANTAS P " &
				  + "WHERE P.COD_PLANTA = PC.COD_PLANTA " &
				  + "AND PC.COD_USR = '" + gs_user + "'"
				  		 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

dw_pd_ot.retrieve(ls_codigo)

dw_master.retrieve(ls_codigo)
end if
end event

event modified;String ls_consumo, ls_consumo_1

ls_consumo = this.text
if ls_consumo = '' or IsNull(ls_consumo) then
	MessageBox('Aviso', 'Debe Ingresar un Nro de Cosnumo')
	return
end if

SELECT NRO_CONSUMO INTO :ls_consumo_1
  FROM PROD_CONSUMO_ENER
 WHERE NRO_CONSUMO 		=:ls_consumo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Nro. De Consumo no existe')
	return
end if

dw_pd_ot.retrieve(ls_consumo)

dw_master.retrieve(ls_consumo)
end event

type cb_2 from commandbutton within w_pr017_prod_ener_recibo
integer x = 2162
integer y = 1772
integer width = 581
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Prorratear Diferencia"
end type

event clicked;
if dw_master.ii_update = 1 then
			
			messagebox('Control de Energia', 'Antes de Prorratear debe de guardar los Cambios')
			Return
END IF
		
parent.event ue_aceptar()
end event

type sle_diferencia from editmask within w_pr017_prod_ener_recibo
integer x = 1513
integer y = 1800
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_pr017_prod_ener_recibo
integer x = 37
integer y = 1736
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Monto Congelado"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_congelado from editmask within w_pr017_prod_ener_recibo
integer x = 37
integer y = 1800
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_pr017_prod_ener_recibo
integer x = 1504
integer y = 1736
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Diferencia"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_harina from editmask within w_pr017_prod_ener_recibo
integer x = 768
integer y = 1800
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_pr017_prod_ener_recibo
integer x = 750
integer y = 1736
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Monto PH"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr017_prod_ener_recibo
integer x = 23
integer y = 28
integer width = 535
integer height = 312
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type ln_1 from line within w_pr017_prod_ener_recibo
integer linethickness = 8
integer beginx = 32
integer beginy = 1724
integer endx = 2761
integer endy = 1724
end type

type ln_2 from line within w_pr017_prod_ener_recibo
integer linethickness = 8
integer beginx = 32
integer beginy = 1912
integer endx = 2761
integer endy = 1912
end type

