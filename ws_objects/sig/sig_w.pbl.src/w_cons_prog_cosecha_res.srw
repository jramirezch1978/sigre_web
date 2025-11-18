$PBExportHeader$w_cons_prog_cosecha_res.srw
forward
global type w_cons_prog_cosecha_res from w_cns
end type
type dw_1 from datawindow within w_cons_prog_cosecha_res
end type
end forward

global type w_cons_prog_cosecha_res from w_cns
integer x = 73
integer y = 100
integer width = 3589
integer height = 1448
string title = "Proyección de Cosecha - Resumen"
string menuname = "m_rpt_simple"
dw_1 dw_1
end type
global w_cons_prog_cosecha_res w_cons_prog_cosecha_res

forward prototypes
public subroutine uof_carga ()
end prototypes

public subroutine uof_carga ();Long ln_tot_reg
ln_tot_reg = 	w_ca500_proy_cosecha.dw_reporte.RowCount()
if ln_tot_reg = 0 Then
	Return
End if

// para calcular días hábiles //
date ld_fecha1, ld_fecha2
String ls_fecha1, ls_fecha2
Integer li_dia, li_diahabil
// para otros casos 
String ls_mes, ls_ano
Long ll_det_has_netas, ll_det_cana_total, ll_det_edad, ll_det_tmcnhn, &
     ll_det_sacarosa, ll_det_recupera, ll_det_AzucarTotal
Long ln_reg, ln_new_reg
Long ll_sum_has_netas, ll_sum_CanaTotal_edad, ll_sum_CanaTotal, ll_sum_HasNetas_tmcnhn, &
     ll_sum_sacarosa_CanaTotal, ll_sum_recupera_CanaTotal, ll_sum_AzucarTotal
Long ll_res_edad, ll_res_CanaTotal, ll_res_sacarosa, ll_res_recupera, ll_res_AzucarTotal
ls_mes = w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'mes' )
ls_ano = w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'ano' )
ll_sum_has_netas = 0
For ln_reg=1 to ln_tot_reg
	 Do while ls_mes <> 	w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'mes' )
		 // tomando valores del detalle
		 ll_det_has_netas  = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'has_netas' )
		 ll_det_cana_total = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'cana_total' )
		 ll_det_edad       = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'edad' )
		 ll_det_tmcnhn     = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'tmcnhn' )
		 ll_det_sacarosa   = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'sacarosa_esperada' )
		 ll_det_recupera   = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'rend_esperado' )
		 ll_det_AzucarTotal =w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'azucar_total' )
		 // acumulando 
		 ll_sum_has_netas  = ll_sum_has_netas + ll_det_has_netas
		 ll_sum_CanaTotal_edad = ll_sum_CanaTotal_edad + ll_det_cana_total * ll_det_edad
		 ll_sum_CanaTotal  = ll_sum_CanaTotal + ll_det_cana_total
		 ll_sum_HasNetas_tmcnhn = ll_sum_HasNetas_tmcnhn + ll_det_has_netas * ll_det_tmcnhn
		 ll_sum_sacarosa_CanaTotal = ll_sum_sacarosa_CanaTotal + ll_det_sacarosa * ll_det_cana_total
		 ll_sum_recupera_CanaTotal = ll_sum_recupera_CanaTotal + ll_det_recupera * ll_det_cana_total
		 ll_sum_AzucarTotal = ll_sum_AzucarTotal + ll_det_AzucarTotal
		 
    Loop 
	 // cálcula días hábiles //
	 ld_fecha1 = date( '01/' + ls_mes + '/' + ls_ano )
    For li_dia = 25 to 32
	     If Month(RelativeDate( ld_fecha1, li_dia)) = Integer(ls_mes) Then
           ld_fecha2 = RelativeDate( ld_fecha1, li_dia)
        End If
    Next
	 Select count(*) 
	   into :li_DiaHabil
      from calendario 
	  where fecha between :ld_fecha1 and :ld_fecha2 ;

	 // calculos //
	 ll_res_edad = ll_sum_CanaTotal_edad / ll_sum_CanaTotal
	 ll_res_CanaTotal = ll_sum_CanaTotal
	 ll_res_sacarosa  = ll_sum_sacarosa_CanaTotal / ll_sum_CanaTotal
	 ll_res_recupera  = ll_sum_recupera_CanaTotal / ll_sum_CanaTotal
	 ll_res_AzucarTotal = ll_sum_AzucarTotal
	 ln_new_reg = dw_1.InsertRow(0)
	 dw_1.SetItem( ln_new_reg, 'has_netas', ll_sum_has_netas )
	 dw_1.SetItem( ln_new_reg, 'edad', ll_res_edad )
	 dw_1.SetItem( ln_new_reg, 'tmcnhn', ll_sum_HasNetas_tmcnhn / ll_sum_has_netas )
	 dw_1.SetItem( ln_new_reg, 'cana_total', ll_res_CanaTotal )
	 dw_1.SetItem( ln_new_reg, 'cana_ano', ll_sum_CanaTotal * 12 / ll_res_edad )
	 dw_1.SetItem( ln_new_reg, 'sacarosa_esperada', ll_res_sacarosa )
	 dw_1.SetItem( ln_new_reg, 'rend_esperado', ll_res_recupera )
	 dw_1.SetItem( ln_new_reg, 'azucar_ha', &
	               ll_res_CanaTotal * ll_res_sacarosa * ll_res_recupera / 10000 )
	 dw_1.SetItem( ln_new_reg, 'azucar_total', ll_res_AzucarTotal )
	 dw_1.SetItem( ln_new_reg, 'azucar_ano', ll_res_AzucarTotal * 12 / ll_res_edad )
	 dw_1.SetItem( ln_new_reg, 'dias_habiles', li_DiaHabil )
	 dw_1.SetItem( ln_new_reg, 'dias_cana', ll_res_CanaTotal / li_DiaHabil )
	 
Next	

end subroutine

on w_cons_prog_cosecha_res.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_cons_prog_cosecha_res.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;Long ln_tot_reg
ln_tot_reg = 	w_ca500_proy_cosecha.dw_reporte.RowCount()
if ln_tot_reg = 0 Then
	Return
End if

// para calcular días hábiles //
Date    ld_fecha1, ld_fecha2
String  ls_fecha1, ls_fecha2
Integer li_dia, li_diahabil
// para otros casos 
String ls_mes, ls_ano
Decimal ll_det_has_netas, ll_det_cana_total, ll_det_edad, ll_det_tmcnhn, &
        ll_det_sacarosa, ll_det_recupera, ll_det_AzucarTotal,ll_azucar_ha
Decimal ln_reg, ln_new_reg
Decimal ll_sum_has_netas, ll_sum_CanaTotal_edad, ll_sum_CanaTotal, ll_sum_HasNetas_tmcnhn, &
        ll_sum_sacarosa_CanaTotal, ll_sum_recupera_CanaTotal, ll_sum_AzucarTotal
Decimal ll_res_edad, ll_res_CanaTotal, ll_res_sacarosa, ll_res_recupera, ll_res_AzucarTotal, &
        ll_res_tmcnhn, ll_res_cana_ano, ll_res_azucar_ano, ll_res_dias_cana
ll_sum_has_netas = 0
ln_reg = 1
Do While ln_reg <= ln_tot_reg
	
   ls_mes = 	w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'mes' )
   ls_ano = 	w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'ano' )
	
	ll_sum_has_netas          = 0
	ll_sum_CanaTotal_edad     = 0
	ll_sum_CanaTotal          = 0
	ll_sum_HasNetas_tmcnhn    = 0
	ll_sum_sacarosa_CanaTotal = 0
	ll_sum_recupera_CanaTotal = 0
   ll_sum_AzucarTotal        = 0
	ll_azucar_ha 				  = 0
	
	Do While ln_reg <= ln_tot_reg and &
		      ls_mes = w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'mes' )
		 // tomando valores del detalle
		 ll_det_has_netas  = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'has_netas' )
		 ll_det_cana_total = w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'cana_total' )
		 ll_det_edad       =	w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'edad' )
		 ll_det_tmcnhn     =	w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'tmcnhn' )
		 ll_det_sacarosa   =	w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'sacarosa_esperada' )
		 ll_det_recupera   =	w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'rend_esperado' )
		 ll_det_AzucarTotal= w_ca500_proy_cosecha.dw_reporte.GetItemNumber( ln_reg, 'azucar_total' )
		 // acumulando 
		 ll_sum_has_netas  = ll_sum_has_netas + ll_det_has_netas
		 ll_sum_CanaTotal_edad = ll_sum_CanaTotal_edad + ll_det_cana_total * ll_det_edad
		 ll_sum_CanaTotal  = ll_sum_CanaTotal + ll_det_cana_total
		 ll_sum_HasNetas_tmcnhn = ll_sum_HasNetas_tmcnhn + ll_det_has_netas * ll_det_tmcnhn
		 ll_sum_sacarosa_CanaTotal = ll_sum_sacarosa_CanaTotal + ll_det_sacarosa * ll_det_cana_total
		 ll_sum_recupera_CanaTotal = ll_sum_recupera_CanaTotal + ll_det_recupera * ll_det_cana_total
		 ll_sum_AzucarTotal = ll_sum_AzucarTotal + ll_det_AzucarTotal
       ln_reg = ln_reg + 1
		 
		 If ln_reg > ln_tot_reg then
		    exit
       End if
    Loop 
	 
 	 // cálcula días hábiles //
	  
    ld_fecha1 = date( '01/' + ls_mes + '/' + ls_ano )
	 
    For li_dia = 25 to 32
        If Month(RelativeDate( ld_fecha1, li_dia)) = Integer(ls_mes) Then
           ld_fecha2 = RelativeDate( ld_fecha1, li_dia)
        End If
    Next
	 
    SELECT count(*) 
	   INTO :li_DiaHabil
      FROM calendario 
	  WHERE fecha   BETWEEN :ld_fecha1 AND :ld_fecha2  AND flag_laborable = 'L' ;

    ll_res_CanaTotal   = ll_sum_CanaTotal
    ll_res_AzucarTotal = ll_sum_AzucarTotal
	 
    // res_Edad //
	 
    If ll_sum_CanaTotal <> 0 Then
     	 ll_res_edad = ll_sum_CanaTotal_edad / ll_sum_CanaTotal
    Else
     	 ll_res_edad = 0
    End If
	 
    // ll_res_tmcnhn //
	 
    If ll_sum_has_netas <> 0 Then
       ll_res_tmcnhn = ll_sum_HasNetas_tmcnhn / ll_sum_has_netas
    Else
       ll_res_tmcnhn = 0
    End If
	 
    // ll_res_cana_ano y ll_res_azucar_ano//
    If ll_res_edad <> 0 Then
       ll_res_cana_ano   = ll_sum_CanaTotal   * 12 / ll_res_edad
 		 
    Else
       ll_res_cana_ano   = 0
 		 ll_res_azucar_ano = 0
    End If
	 
    // dias_cana //
    If li_DiaHabil  <> 0 Then
       ll_res_dias_cana = ll_res_CanaTotal / li_DiaHabil 
    Else
       ll_res_dias_cana = 0
    End If
    // sacarosa y recupera //
    If ll_sum_CanaTotal  <> 0 Then
       ll_res_sacarosa  = ll_sum_sacarosa_CanaTotal / ll_sum_CanaTotal
    Else
       ll_res_sacarosa  = 0
    End If
	 
	 //recupera
	 If ll_sum_has_netas   <> 0 Then
       ll_res_recupera  =  ll_res_CanaTotal / ll_sum_has_netas 
		 
    Else
       ll_res_recupera  = 0
    End If
	 
	 //caña_x_ano
	 IF ll_res_edad <> 0 THEN
	    ll_res_cana_ano = (ll_res_recupera * 12 ) / ll_res_edad
	 ELSE
		 ll_res_cana_ano = 0 
	 END IF
	 
	 
	 IF ll_sum_has_netas <> 0 THEN
		 ll_azucar_ha = ll_res_azucartotal / ll_sum_has_netas
	 ELSE
		 ll_azucar_ha = 0
	 END IF	
	 
	 IF ll_res_edad <> 0 THEN
   	 ll_res_azucar_ano = (ll_azucar_ha * 12 ) / ll_res_edad
	 ELSE
	    ll_res_azucar_ano = 0
	 END IF
	 
	 
    ln_new_reg = dw_1.InsertRow(0)
    dw_1.SetItem( ln_new_reg, 'mes', ls_mes )
    dw_1.SetItem( ln_new_reg, 'ano', ls_ano )
    dw_1.SetItem( ln_new_reg, 'has_netas', ll_sum_has_netas )
    dw_1.SetItem( ln_new_reg, 'edad', ll_res_edad )
    dw_1.SetItem( ln_new_reg, 'tmcnhn', ll_res_tmcnhn )
    dw_1.SetItem( ln_new_reg, 'cana_total', ll_res_CanaTotal )
    dw_1.SetItem( ln_new_reg, 'cana_ano', ll_res_cana_ano )
    dw_1.SetItem( ln_new_reg, 'sacarosa_esperada', ll_res_sacarosa )
    dw_1.SetItem( ln_new_reg, 'rend_esperado', ll_res_recupera )
    dw_1.SetItem( ln_new_reg, 'azucar_ha', ll_azucar_ha        )
    dw_1.SetItem( ln_new_reg, 'azucar_total', ll_res_AzucarTotal )
    dw_1.SetItem( ln_new_reg, 'azucar_ano', ll_res_azucar_ano )
    dw_1.SetItem( ln_new_reg, 'dias_habiles', li_DiaHabil )
    dw_1.SetItem( ln_new_reg, 'dias_cana', ll_res_dias_cana )
	 
   
Loop

end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event ue_open_pre;call super::ue_open_pre;this.x = 30
this.y = 400

end event

type dw_1 from datawindow within w_cons_prog_cosecha_res
integer x = 14
integer y = 12
integer width = 3515
integer height = 1208
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_cons_prog_cosecha_res"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

