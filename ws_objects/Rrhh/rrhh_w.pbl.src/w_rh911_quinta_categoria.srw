$PBExportHeader$w_rh911_quinta_categoria.srw
forward
global type w_rh911_quinta_categoria from w_abc
end type
type sle_obs from singlelineedit within w_rh911_quinta_categoria
end type
type st_13 from statictext within w_rh911_quinta_categoria
end type
type st_12 from statictext within w_rh911_quinta_categoria
end type
type em_tope_max from editmask within w_rh911_quinta_categoria
end type
type st_11 from statictext within w_rh911_quinta_categoria
end type
type em_saldo from editmask within w_rh911_quinta_categoria
end type
type em_uit from editmask within w_rh911_quinta_categoria
end type
type st_10 from statictext within w_rh911_quinta_categoria
end type
type em_aplicacion from editmask within w_rh911_quinta_categoria
end type
type em_base from editmask within w_rh911_quinta_categoria
end type
type st_9 from statictext within w_rh911_quinta_categoria
end type
type st_8 from statictext within w_rh911_quinta_categoria
end type
type st_7 from statictext within w_rh911_quinta_categoria
end type
type em_tasa from editmask within w_rh911_quinta_categoria
end type
type em_tope_min from editmask within w_rh911_quinta_categoria
end type
type em_ing from editmask within w_rh911_quinta_categoria
end type
type st_6 from statictext within w_rh911_quinta_categoria
end type
type st_5 from statictext within w_rh911_quinta_categoria
end type
type st_4 from statictext within w_rh911_quinta_categoria
end type
type st_3 from statictext within w_rh911_quinta_categoria
end type
type pb_2 from picturebutton within w_rh911_quinta_categoria
end type
type pb_1 from picturebutton within w_rh911_quinta_categoria
end type
type cb_2 from commandbutton within w_rh911_quinta_categoria
end type
type cb_1 from commandbutton within w_rh911_quinta_categoria
end type
type dw_1 from datawindow within w_rh911_quinta_categoria
end type
type st_2 from statictext within w_rh911_quinta_categoria
end type
type st_1 from statictext within w_rh911_quinta_categoria
end type
type dw_2 from u_dw_abc within w_rh911_quinta_categoria
end type
type dw_master from u_dw_abc within w_rh911_quinta_categoria
end type
type gb_2 from groupbox within w_rh911_quinta_categoria
end type
type gb_1 from groupbox within w_rh911_quinta_categoria
end type
end forward

global type w_rh911_quinta_categoria from w_abc
integer width = 3831
integer height = 2364
string title = "(RH911) Cuadro de Retenciones "
string menuname = "m_modifica_graba_print"
long backcolor = 67108864
sle_obs sle_obs
st_13 st_13
st_12 st_12
em_tope_max em_tope_max
st_11 st_11
em_saldo em_saldo
em_uit em_uit
st_10 st_10
em_aplicacion em_aplicacion
em_base em_base
st_9 st_9
st_8 st_8
st_7 st_7
em_tasa em_tasa
em_tope_min em_tope_min
em_ing em_ing
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
pb_2 pb_2
pb_1 pb_1
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
st_2 st_2
st_1 st_1
dw_2 dw_2
dw_master dw_master
gb_2 gb_2
gb_1 gb_1
end type
global w_rh911_quinta_categoria w_rh911_quinta_categoria

forward prototypes
public subroutine of_calculo_retenciones ()
public function integer of_get_uit ()
end prototypes

public subroutine of_calculo_retenciones ();Decimal {2} ldc_tasa,ldc_tope_ini,ldc_tope_fin,ldc_tot_ing,ldc_tot_ret,&
				ldc_tope_minimo, ldc_retencion
Date 			ld_fecha
Integer		li_year
dw_master.accepttext( )

if dw_master.Rowcount( ) > 0 then
	/*Datos Basico*/
	
	li_year	   = Integer(dw_master.object.ano   [1])
	ldc_tot_ing = Dec(dw_master.object.total_ing [1])
	ldc_tot_ret = Dec(dw_master.object.tot_ret   [1])
	ld_fecha	   = date(li_year, 1, 1)
	
	select min(ri.tope_fin) 
	  into :ldc_tope_minimo 
	  from rrhh_impuesto_renta ri 
	 where trunc(:ld_fecha) between trunc(ri.fecha_vig_ini) and trunc(ri.fecha_vig_fin) ;
	/**/
	
	if SQLCA.SQLCode = 100 then
		Rollback;
		MessageBox('Aviso', 'no ha especificado parámetros para el Impuesto de Quinta Categoría')
		return
	end if
	
	select tasa,tope_fin 
	  into :ldc_tasa,:ldc_tope_fin
	  from rrhh_impuesto_renta ri 
	where :ld_fecha between ri.fecha_vig_ini and ri.fecha_vig_fin 
	  and :ldc_tot_ing between ri.tope_ini and ri.tope_fin ;
	
	
	//verificar que es importe minimo
	ldc_tope_ini = Round(Dec(em_uit.text) * 7,2)
	
	ldc_retencion = f_calc_quinta_categ(ldc_tot_ing - ldc_tope_ini, li_year) 
			 
	em_ing.text        = String(ldc_tot_ing)
	em_tasa.text       = String(ldc_tasa)
	em_tope_min.text   = String(ldc_tope_ini)
	em_tope_max.text	 = String(ldc_tope_fin)
	em_base.text 		 = String(ldc_tot_ing - ldc_tope_ini)
	em_aplicacion.text = String(ldc_retencion) //String( (ldc_tot_ing - ldc_tope_ini ) * (ldc_tasa / 100))
	em_saldo.text		 = String(ldc_retencion - ldc_tot_ret)			
end if			
		
		

		
end subroutine

public function integer of_get_uit ();Decimal {2}		ldc_uit
Date				ld_fecha
Integer			li_year

li_year = Integer(dw_1.object.ano [1])

if IsNull(li_year) or li_year = 0 then
	MessageBox('Aviso', 'Debe indicar una fecha válida')
	return 0
end if

em_uit.text = String(f_get_uit(li_year))

return 1
end function

on w_rh911_quinta_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba_print" then this.MenuID = create m_modifica_graba_print
this.sle_obs=create sle_obs
this.st_13=create st_13
this.st_12=create st_12
this.em_tope_max=create em_tope_max
this.st_11=create st_11
this.em_saldo=create em_saldo
this.em_uit=create em_uit
this.st_10=create st_10
this.em_aplicacion=create em_aplicacion
this.em_base=create em_base
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.em_tasa=create em_tasa
this.em_tope_min=create em_tope_min
this.em_ing=create em_ing
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.st_2=create st_2
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_master=create dw_master
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_obs
this.Control[iCurrent+2]=this.st_13
this.Control[iCurrent+3]=this.st_12
this.Control[iCurrent+4]=this.em_tope_max
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.em_saldo
this.Control[iCurrent+7]=this.em_uit
this.Control[iCurrent+8]=this.st_10
this.Control[iCurrent+9]=this.em_aplicacion
this.Control[iCurrent+10]=this.em_base
this.Control[iCurrent+11]=this.st_9
this.Control[iCurrent+12]=this.st_8
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.em_tasa
this.Control[iCurrent+15]=this.em_tope_min
this.Control[iCurrent+16]=this.em_ing
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.pb_2
this.Control[iCurrent+22]=this.pb_1
this.Control[iCurrent+23]=this.cb_2
this.Control[iCurrent+24]=this.cb_1
this.Control[iCurrent+25]=this.dw_1
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.st_1
this.Control[iCurrent+28]=this.dw_2
this.Control[iCurrent+29]=this.dw_master
this.Control[iCurrent+30]=this.gb_2
this.Control[iCurrent+31]=this.gb_1
end on

on w_rh911_quinta_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_obs)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.em_tope_max)
destroy(this.st_11)
destroy(this.em_saldo)
destroy(this.em_uit)
destroy(this.st_10)
destroy(this.em_aplicacion)
destroy(this.em_base)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.em_tasa)
destroy(this.em_tope_min)
destroy(this.em_ing)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_master)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.Settransobject(sqlca)
dw_2.Settransobject(sqlca)

idw_1 = dw_master 

end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 30
dw_master.height  = newheight - dw_master.y - 30

sle_obs.height  = newheight - sle_obs.y - 30
gb_1.width  = newwidth  - gb_1.x - 10
gb_1.height = newheight - gb_1.y - 10
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
	of_calculo_retenciones()

END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF

end event

event ue_print;call super::ue_print;String 	ls_cod_tra, ls_obs
Decimal {2} ldc_uit
Integer	li_year

str_seleccionar lstr_seleccionar

if dw_master.Rowcount() > 0 then
	if dw_master.ii_update > 0 then
		Messagebox('Aviso','Tiene Grabaciones Pendientes ,Verifique!')
		Return 
	end if
	ls_cod_tra  = String(dw_master.object.cod_trabajador [1])
	ls_obs		= sle_obs.text
	li_year		= Integer(dw_master.object.ano	 [1])
	ldc_uit		= Dec(em_uit.text)
	
	lstr_seleccionar.param1   [1] = ls_cod_tra
	lstr_seleccionar.param1   [2] = ls_obs
	lstr_seleccionar.paraml1  [1] = li_year
	lstr_seleccionar.paramdc1 [1] = ldc_uit

	OpenSheetWithParm(w_rh718_certificado_retencion, lstr_seleccionar, this, 2, Layered!)
end if	
end event

type sle_obs from singlelineedit within w_rh911_quinta_categoria
integer x = 41
integer y = 1908
integer width = 1623
integer height = 212
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_13 from statictext within w_rh911_quinta_categoria
integer x = 27
integer y = 1844
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Observaciones"
boolean focusrectangle = false
end type

type st_12 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1384
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tope Maximo UIT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tope_max from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1380
integer width = 347
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1732
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Saldo por Pagar :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_saldo from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1724
integer width = 347
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_uit from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1120
integer width = 347
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1136
integer width = 562
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Monto UIT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_aplicacion from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1636
integer width = 347
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_base from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1552
integer width = 347
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1648
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Aplicación Impuesto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1564
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Base Impuesto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_rh911_quinta_categoria
integer x = 1115
integer y = 1480
integer width = 82
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "%"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_tasa from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1464
integer width = 347
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_tope_min from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1296
integer width = 347
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_ing from editmask within w_rh911_quinta_categoria
integer x = 640
integer y = 1208
integer width = 347
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1304
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Topes Minimo UIT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1476
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tasa para UIT :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh911_quinta_categoria
integer x = 46
integer y = 1212
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ingresos Promedios :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh911_quinta_categoria
integer x = 1824
integer y = 76
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Eliminar Registro"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_rh911_quinta_categoria
integer x = 1714
integer y = 68
integer width = 101
integer height = 88
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "DeleteRow!"
alignment htextalign = left!
end type

event clicked;Long ll_row

ll_row = dw_master.Getrow()

IF ll_row = 0 then
	Messagebox('Aviso','Debe Seleccionar Algun Registro , Verifique!')
	Return
ELSE
	dw_master.deleterow(ll_row)
	dw_master.ii_update = 1
	dw_master.GroupCalc()
	of_calculo_retenciones ()
END IF
end event

type pb_1 from picturebutton within w_rh911_quinta_categoria
integer x = 23
integer y = 604
integer width = 101
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "ScriptNo!"
alignment htextalign = left!
end type

event clicked;String 	ls_cod_trabajador,ls_nombres
Integer	li_year



if dw_master.Rowcount() > 0 then
	
	ls_cod_trabajador = dw_master.object.cod_trabajador [1]
	ls_nombres			= dw_master.object.nombres			 [1]
	li_year		  		= Integer(dw_master.object.ano	 [1])
	
	dw_2.Reset( )
	dw_2.InsertRow(0)
	dw_2.object.cod_trabajador [1] = ls_cod_trabajador
	dw_2.object.nombres		   [1] = ls_nombres		
	dw_2.object.tipo_concepto	[1] = '1'		
	dw_2.object.ano				[1] = li_year

	
end if


end event

type cb_2 from commandbutton within w_rh911_quinta_categoria
integer x = 1312
integer y = 584
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;String ls_expresion,ls_columnas
Long   ll_flag_grupo,ll_count
Decimal {2} ldc_valor


dw_2.accepttext()

if dw_2.Rowcount() > 0 then
	ll_flag_grupo = Long(dw_2.object.flag_grupo [1])
	ls_columnas	  = dw_2.object.columnas   	  [1]
	ldc_valor	  = Dec(dw_2.object.valor	     [1])

	
	if Isnull(ll_flag_grupo) then
		Messagebox('Aviso','Debe Indicar algun grupo, Verifique!')
		dw_2.SetColumn('flag_grupo')
		dw_2.Setfocus()
		Return
	end if
	
	If Isnull(ls_columnas) or Trim(ls_columnas) = '' then
		Messagebox('Aviso','Debe Indicar algun Concepto , Verifique!')
		dw_2.SetColumn('columnas')
		dw_2.Setfocus()
		Return
	end if
	
	If Isnull(ldc_valor) or ldc_valor = 0 then
		Messagebox('Aviso','Debe Indicar algun Monto mayor a 0 , Verifique!')
		dw_2.SetColumn('valor')
		dw_2.Setfocus()
		Return
	end if
	
	
	ls_expresion = 'flag_grupo = '+ trim(String(ll_flag_grupo))
	dw_master.SetFilter(ls_expresion)
	dw_master.Filter( )

	ll_count = dw_master.rowcount() + 1

	dw_2.object.item [1] = ll_count 


	dw_2.RowsCopy(1,1, Primary!, dw_master, 1, Primary!)
	dw_master.ii_update = 1
	
	dw_master.SetFilter('')
	dw_master.Filter( )
	dw_master.SetSort('flag_grupo, item')
	dw_master.Sort()
	dw_master.GroupCalc()

	//limpiar registro
	pb_1.TriggerEvent(Clicked!)
end if	
end event

type cb_1 from commandbutton within w_rh911_quinta_categoria
integer x = 1271
integer y = 60
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_cod_trabajador, ls_mensaje
Long    ll_count 
Integer li_opcion = 1, li_year

dw_1.Accepttext()

if dw_master.ii_update > 0 then
	Messagebox('Aviso','Tiene Grabaciones Pendientes ,Verifique!')
	Return 
end if

ls_cod_trabajador = dw_1.object.cod_trabajador [1]
li_year			   = Integer(dw_1.object.ano	  [1])

if Isnull(ls_cod_trabajador) or trim(ls_cod_trabajador) = '' then
	Messagebox('Aviso','Debe ingresar Codigo de Trabajador')
	Return
end if

if Isnull(li_year) or li_year = 0 then
	Messagebox('Aviso','Debe ingresar Año a Procesar')
	Return
end if


//buscar trabajador y año
select count(*) 
 into :ll_count 
 from rrhh_formato_quinta_cat
where cod_trabajador = :ls_cod_trabajador 
  and ano				= :li_year;

if ll_count > 0 then
	li_opcion = MessageBox('Aviso','Desea Regenerar Formato de Retenciones de Quinta Categoria',Question!, yesno!, 2)	
end if

if li_opcion = 1 then
	DECLARE usp_rh_cuadro_ret_quinta_cat PROCEDURE FOR 
		usp_rh_cuadro_ret_quinta_cat( :ls_cod_trabajador,
												:li_year);
	EXECUTE usp_rh_cuadro_ret_quinta_cat ;

	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = "ERROR EN PROCEDURE usp_rh_cuadro_ret_quinta_cat: " + SQLCA.sqlerrtext
		MessageBox("SQL error", ls_mensaje)
		Rollback;
		return
	END IF
	
	CLOSE usp_rh_cuadro_ret_quinta_cat;
	
	dw_master.ii_update = 1
	
end if

dw_master.Retrieve(ls_cod_trabajador,li_year)
of_calculo_retenciones ()

end event

type dw_1 from datawindow within w_rh911_quinta_categoria
integer x = 27
integer y = 180
integer width = 1632
integer height = 300
integer taborder = 40
string title = "none"
string dataobject = "d_ext_datos_a_procesar"
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

event itemchanged;String ls_nombre, ls_null

SetNull(ls_null)
Accepttext()

choose case dwo.name
	case 'cod_trabajador'
		select Nvl(apel_paterno,' ')||' '||Nvl(apel_materno,' ')||' '||Nvl(nombre1,' ')||' '||Nvl(nombre2,' ')
		  into :ls_nombre
		  from maestro 
		 where cod_trabajador = :data
		   and flag_estado = '1'; 
						  
		if sqlca.sqlcode = 100 then
			Messagebox('Aviso','Codigo de trabajador No Existe o no está activo,Verifique!')
			this.object.cod_trabajador	[row] = ls_null
			this.object.nombres			[row] = ls_null
			Return 1
		end if
		This.object.nombres [row] = ls_nombre
		
	case 'ano'
		of_get_uit( )
end choose

end event

event itemerror;Return 1
end event

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(dwo.name)
	case "b_1"
		ls_sql = "SELECT CODIGO AS CODIGO_TRABAJADOR, " &
				 + "NOMBRE AS NOMBRE_TRABAJADOR, " &
				 + "DNI as DNI " &
				 + "FROM VW_RRHH_CODREL_MAESTRO "&
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_trabajador [row] = ls_codigo
			this.object.nombres			[row] = ls_data
		end if

end choose




end event

type st_2 from statictext within w_rh911_quinta_categoria
integer x = 18
integer y = 124
integer width = 462
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos a Procesar :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh911_quinta_categoria
integer x = 27
integer y = 504
integer width = 1029
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Registro de Item de Ingreso o Retencion"
boolean focusrectangle = false
end type

type dw_2 from u_dw_abc within w_rh911_quinta_categoria
integer x = 27
integer y = 704
integer width = 1641
integer height = 320
integer taborder = 30
string dataobject = "d_abc_ingresos_x_meses_quinta_cta_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3



idw_mst = dw_2

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()


choose case dwo.name
	  	 case 'flag_grupo'
				if data = '2' then
					this.object.factor [row] = 1
				else
					this.object.factor [row] = -1
				end if

end choose

end event

type dw_master from u_dw_abc within w_rh911_quinta_categoria
integer x = 1701
integer y = 168
integer width = 1856
integer height = 1908
string dataobject = "d_rpt_ingresos_x_meses_quinta_cta_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3



idw_mst = dw_master

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()


choose case dwo.name
		 case 'valor'
				of_calculo_retenciones ()

end choose


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type gb_2 from groupbox within w_rh911_quinta_categoria
integer x = 37
integer y = 1048
integer width = 1637
integer height = 800
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Retencion de Acuerdo a Ingresos "
end type

type gb_1 from groupbox within w_rh911_quinta_categoria
integer x = 14
integer width = 3579
integer height = 2140
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cuadro de Retención"
end type

