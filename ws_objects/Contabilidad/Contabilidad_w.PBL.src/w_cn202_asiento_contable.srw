$PBExportHeader$w_cn202_asiento_contable.srw
forward
global type w_cn202_asiento_contable from w_abc
end type
type cb_saldos from commandbutton within w_cn202_asiento_contable
end type
type cb_1 from commandbutton within w_cn202_asiento_contable
end type
type sle_origen from singlelineedit within w_cn202_asiento_contable
end type
type tab_1 from tab within w_cn202_asiento_contable
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detdet from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detdet dw_detdet
end type
type tab_1 from tab within w_cn202_asiento_contable
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_cn202_asiento_contable
end type
type sle_ano from singlelineedit within w_cn202_asiento_contable
end type
type sle_libro from singlelineedit within w_cn202_asiento_contable
end type
type sle_mes from singlelineedit within w_cn202_asiento_contable
end type
type sle_asiento from singlelineedit within w_cn202_asiento_contable
end type
type st_1 from statictext within w_cn202_asiento_contable
end type
type st_2 from statictext within w_cn202_asiento_contable
end type
type st_3 from statictext within w_cn202_asiento_contable
end type
type st_4 from statictext within w_cn202_asiento_contable
end type
type st_5 from statictext within w_cn202_asiento_contable
end type
type gb_1 from groupbox within w_cn202_asiento_contable
end type
end forward

global type w_cn202_asiento_contable from w_abc
integer width = 4357
integer height = 2156
string title = "Mantenimiento de Asientos Contables (CN202)"
string menuname = "m_abc_asiento_contable"
event ue_anular ( )
event ue_cancelar ( )
cb_saldos cb_saldos
cb_1 cb_1
sle_origen sle_origen
tab_1 tab_1
dw_master dw_master
sle_ano sle_ano
sle_libro sle_libro
sle_mes sle_mes
sle_asiento sle_asiento
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
gb_1 gb_1
end type
global w_cn202_asiento_contable w_cn202_asiento_contable

type variables
BOOLEAN 				ib_chk_fecha_cntbl, ib_estado[]
STRING 				is_det_glosa, is_opcion
Datawindowchild 	idwch_doc_ref
u_dw_abc				idw_detail, idw_auxiliar
n_cst_asiento_contable	invo_asiento_cntbl

end variables

forward prototypes
public subroutine of_chk ()
public function boolean of_recupera_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento)
public subroutine of_refleja_total ()
public function integer uf_nro_asiento (integer an_libro, integer an_mes, integer an_ano, string as_origen)
public subroutine of_accepttext ()
public subroutine of_calcula_totales ()
public subroutine of_modify_dws ()
public subroutine of_retrieve (str_parametros astr_param)
public subroutine of_asigna_dws ()
end prototypes

event ue_anular;String ls_origen, ls_flag_tabla, ls_flag_estado
Integer li_item
Long ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_item, ll_row


if dw_master.ii_update = 1 or idw_detail.ii_update = 1 then 
	f_mensaje("Debe grabar primero los cambios antes de anular el documento", "")
	return
end if

is_action = 'anular'

// 1ro Verificando si se encuentra ubicado en un asiento contable y es del tipo Voucher
ll_row = dw_master.Getrow()

if ll_row = 0 then return

ls_origen 		= dw_master.GetItemString(ll_row,'origen')
ll_ano    		= dw_master.GetItemNumber(ll_row,'ano')
ll_mes    		= dw_master.GetItemNumber(ll_row,'mes')
ll_nro_libro 	= dw_master.GetItemNumber(ll_row,'nro_libro')
ll_nro_asiento = dw_master.GetItemNumber(ll_row,'nro_asiento')
ls_flag_tabla  = dw_master.GetItemString(ll_row,'flag_tabla')
ls_flag_estado = dw_master.GetItemString(ll_row,'flag_estado')

IF ls_flag_tabla <> 'V' then
	messagebox('Aviso', 'Asiento contable no se puede anular por esta opción')
	return
end if

IF ls_flag_estado = '0' then
	messagebox('Aviso', 'Asiento contable ya esta anulado')
	return
end if

if not invo_asiento_cntbl.of_val_mes_cntbl( ll_ano, ll_mes, 'M' ) then return

//Anulo la cabecera
dw_master.object.flag_estado 	[ll_row] = '0'
dw_master.object.tot_soldeb	[ll_row] = 0.00
dw_master.object.tot_solhab	[ll_row] = 0.00
dw_master.object.tot_doldeb	[ll_row] = 0.00
dw_master.object.tot_dolhab	[ll_row] = 0.00
dw_master.ii_update = 1


// 3ro Dejar en 0 el 1er item del detalle del asiento contable
FOR li_item = 1 TO idw_detail.rowcount()
	idw_detail.Object.imp_movsol[li_item] = 0
	idw_detail.Object.imp_movdol[li_item] = 0
	idw_detail.ii_update = 1
NEXT 


return
end event

event ue_cancelar();rollback ;
tab_1.tabpage_2.dw_detdet.reset()
tab_1.tabpage_1.dw_detail.reset()
dw_master.reset()


end event

public subroutine of_chk ();//dw_master.Setitem(row,"nro_asiento",ll_comprobante)
// Objetivo : Controlar la grabación e informar al usuario sobre posibles faltantes
If dw_master.GetColumnName() <> 'cuenta' Then 
   dw_master.AcceptText()
End if

boolean lb1, lb2
string  lsb
lb1 = not ib_chk_fecha_cntbl
lb2 = dw_master.GetItemNumber( dw_master.il_row, 'nro_asiento' ) <= 0
if isnull (lb2) then lb2 = true
lsb = '' 
if lb1 then lsb = lsb + '1)FechaContable/TipoCambio' + ' '
if lb2 then lsb = lsb + '2)NroAsiento/Libro' + ' '
This.SetMicroHelp( lsb )

end subroutine

public function boolean of_recupera_asiento (string as_origen, long al_ano, long al_mes, long al_nro_libro, long al_nro_asiento);if isnull(as_origen) or isnull(al_ano) or isnull(al_mes) then
	return false
end if


if isnull(al_nro_libro) or isnull(al_nro_asiento) then
	return false
end if

return true

end function

public subroutine of_refleja_total ();dw_master.SetItem( dw_master.il_row, 'tot_soldeb', &
   tab_1.tabpage_1.dw_detail.GetItemNumber( tab_1.tabpage_1.dw_detail.RowCount(), 'debe_sol' ) )
dw_master.SetItem( dw_master.il_row, 'tot_doldeb', &
   tab_1.tabpage_1.dw_detail.GetItemNumber( tab_1.tabpage_1.dw_detail.RowCount(), 'debe_dol' ) )
dw_master.SetItem( dw_master.il_row, 'tot_solhab', &
   tab_1.tabpage_1.dw_detail.GetItemNumber( tab_1.tabpage_1.dw_detail.RowCount(), 'haber_sol' ) )
dw_master.SetItem( dw_master.il_row, 'tot_dolhab', &
  tab_1.tabpage_1.dw_detail.GetItemNumber( tab_1.tabpage_1.dw_detail.RowCount(), 'haber_dol' ) )

end subroutine

public function integer uf_nro_asiento (integer an_libro, integer an_mes, integer an_ano, string as_origen);long ll_comprobante, ll_reg

SELECT count(*)
 Into :ll_reg
 From cntbl_libro_mes 
 Where origen 		= :as_origen and 
       nro_libro 	= :an_libro and
       ano 			= :an_ano and
       mes 			= :an_mes;

if isnull(ll_reg) or ll_reg = 0 Then
	ll_comprobante = 1
	Insert Into cntbl_libro_mes( origen, nro_libro, ano, mes, nro_asiento )
	       Values ( :as_origen, :an_libro, :an_ano, :an_mes, :ll_comprobante );
	Commit;		  
end if

IF ll_reg > 0 then
	SELECT c.nro_asiento
 	Into :ll_comprobante
 	From cntbl_libro_mes c
 	Where c.origen = :as_origen and
       c.nro_libro = :an_libro and
       c.ano = :an_ano and
       c.mes = :an_mes for update ;
end if

/*
Update cntbl_libro_mes set nro_asiento = :ll_comprobante + 1
  Where origen 	= :as_origen and
        nro_libro = :an_libro and
        ano 		= :an_ano and
        mes 		= :an_mes;*/


Return ll_comprobante
end function

public subroutine of_accepttext ();dw_master.accepttext()
idw_detail.accepttext()

end subroutine

public subroutine of_calcula_totales ();integer 	li_j
Decimal	ldc_debe_sol = 0, ldc_debe_dol = 0, &
			ldc_haber_sol = 0, ldc_haber_dol = 0
u_dw_abc ldw_detail

ldw_detail = tab_1.tabpage_1.dw_detail

for li_j = 1 to ldw_detail.RowCount()
	IF ldw_detail.object.flag_debhab[li_j] = 'D' then
		ldc_debe_sol = ldc_debe_sol + ldw_detail.object.imp_movsol[li_j]
		ldc_debe_dol = ldc_debe_dol + ldw_detail.object.imp_movdol[li_j]
	ELSE
		ldc_haber_sol = ldc_haber_sol + ldw_detail.object.imp_movsol[li_j]
		ldc_haber_dol = ldc_haber_dol + ldw_detail.object.imp_movdol[li_j]
	END IF
next

/*if ldc_debe_sol<>ldc_haber_sol or ldc_debe_dol<>ldc_haber_dol then
	Messagebox( "Error", "Asiento descuadrado", Exclamation!)
	Return
end if
*/

dw_master.SetItem( dw_master.GetRow(), 'tot_soldeb', ldc_debe_sol )
dw_master.SetItem( dw_master.GetRow(), 'tot_solhab', ldc_haber_sol )
dw_master.SetItem( dw_master.GetRow(), 'tot_doldeb', ldc_debe_dol )
dw_master.SetItem( dw_master.GetRow(), 'tot_dolhab', ldc_haber_dol )
dw_master.ii_update = 1

end subroutine

public subroutine of_modify_dws ();//bloqueo de campos....
idw_detail.Modify("cencos.Protect       ='1 ~t If(flag_cencos=~~'0~~',1,0)'")		
idw_detail.Modify("cencos.Edit.Required ='1 ~t If(flag_cencos=~~'1~~',1,0)'")		

idw_detail.Modify("cod_relacion.Protect ='1 ~t If(flag_codrel=~~'0~~',1,0)'")			
idw_detail.Modify("cod_relacion.Edit.Required ='1 ~t If(flag_codrel=~~'1~~',1,0)'")			

idw_detail.Modify("tipo_docref1.Protect ='1 ~t If(flag_doc_ref=~~'0~~',1,0)'")			
idw_detail.Modify("tipo_docref1.Edit.Required ='1 ~t If(flag_doc_ref=~~'1~~',1,0)'")			

idw_detail.Modify("nro_docref1.Protect  ='1 ~t If(flag_doc_ref=~~'0~~',1,0)'")			
idw_detail.Modify("nro_docref1.Edit.Required  ='1 ~t If(flag_doc_ref=~~'1~~',1,0)'")			

idw_detail.Modify("centro_benef.Protect ='1 ~t If(flag_centro_benef=~~'0~~',1,0)'")			
idw_detail.Modify("centro_benef.Edit.Required ='1 ~t If(flag_centro_benef=~~'1~~',1,0)'")			

idw_detail.Modify("cod_ctabco.Protect   ='1 ~t If(flag_ctabco=~~'0~~',1,0)'")			
idw_detail.Modify("cod_ctabco.Edit.Required   ='1 ~t If(flag_ctabco=~~'1~~',1,0)'")			

end subroutine

public subroutine of_retrieve (str_parametros astr_param);// Se ubica la cabecera
String ls_origen
Long ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_row

// Refrescando el detalle
ls_origen 		= astr_param.field_ret[1]
ll_ano    		= long(astr_param.field_ret[2])
ll_mes    		= long(astr_param.field_ret[3])
ll_nro_libro 	= long(astr_param.field_ret[4])
ll_nro_asiento = long(astr_param.field_ret[5])


dw_master.Reset()
idw_Detail.Reset()
dw_master.retrieve(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento )
is_opcion='open'
is_action='open'



if dw_master.RowCount() > 0 then
	idw_detail.retrieve(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)
end if

dw_master.ResetUpdate()
idw_detail.ResetUpdate()

of_modify_dws()

dw_master.ii_protect = 0
dw_master.of_protect()
idw_detail.ii_protect = 0
idw_detail.of_protect()

dw_master.ii_update = 0
idw_Detail.ii_update = 0


end subroutine

public subroutine of_asigna_dws ();idw_detail = tab_1.tabpage_1.dw_detail
idw_auxiliar = tab_1.tabpage_2.dw_detdet
end subroutine

on w_cn202_asiento_contable.create
int iCurrent
call super::create
if this.MenuName = "m_abc_asiento_contable" then this.MenuID = create m_abc_asiento_contable
this.cb_saldos=create cb_saldos
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.tab_1=create tab_1
this.dw_master=create dw_master
this.sle_ano=create sle_ano
this.sle_libro=create sle_libro
this.sle_mes=create sle_mes
this.sle_asiento=create sle_asiento
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saldos
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.sle_ano
this.Control[iCurrent+7]=this.sle_libro
this.Control[iCurrent+8]=this.sle_mes
this.Control[iCurrent+9]=this.sle_asiento
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.gb_1
end on

on w_cn202_asiento_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_saldos)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.sle_ano)
destroy(this.sle_libro)
destroy(this.sle_mes)
destroy(this.sle_asiento)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_1)
end on

event resize;call super::resize;of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.width  - idw_detail.x - 50
idw_detail.height = tab_1.height - idw_detail.y - 120

idw_auxiliar.width  = tab_1.width  - idw_auxiliar.x - 80
idw_auxiliar.height = tab_1.height - idw_auxiliar.y - 120


end event

event ue_open_pre;call super::ue_open_pre;String 	ls_origen
Long 		ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_count
Integer	li_year
str_parametros	lstr_param

of_asigna_dws()

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)

//dw_lista.SetTransObject(sqlca)
idw_1 = dw_master              				// asignar dw corriente

idw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado


invo_asiento_cntbl = create n_cst_asiento_contable

//invo_asiento_cntbl.of_update_asientos()

li_year = integer(string(f_fecha_actual(), 'yyyy'))

// Abriendo el ultimo registro como asiento
SELECT origen, ano, mes, nro_libro, nro_asiento
  INTO :ls_origen, :ll_ano, :ll_mes, :ll_nro_libro, :ll_nro_asiento
  FROM cntbl_asiento 
 WHERE ano = :li_year
   and flag_estado = '1'
 order by ano desc, mes desc, nro_libro desc, nro_Asiento desc;

if SQLCA.SQLCode = 100 then return

// Refrescando el detalle
lstr_param.field_ret[1] = ls_origen
lstr_param.field_ret[2] = string(ll_ano)
lstr_param.field_ret[3] = string(ll_mes)
lstr_param.field_ret[4] = string(ll_nro_libro)
lstr_param.field_ret[5] = string(ll_nro_Asiento)


of_retrieve(lstr_param)

dw_master.setFocus()

end event

event ue_insert;call super::ue_insert;Long  	ll_row
Boolean  lb_flag = FALSE

of_accepttext()

CHOOSE CASE idw_1
	 CASE dw_master
		// Adicionando en dw_master
		TriggerEvent ('ue_update_request')	
		dw_master.Reset()
		idw_detail.Reset()
		
		dw_master.ResetUpdate()
		idw_detail.ResetUpdate()
		
		dw_master.ii_update 	= 0
		idw_detail.ii_update = 0
				  
END CHOOSE

////
ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF
//
end event

event ue_update;Boolean  lbo_ok = TRUE

of_accepttext()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
end if

if is_action = 'anular' then
	
	IF idw_detail.Update(true, false) = -1 then		// Grabacion de detalle de asiento contable
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error en Grabacion Detalle de asiento","Se ha procedido al rollback",exclamation!)
		Return
	END IF

	IF lbo_ok and dw_master.Update(true, false) = -1 then		// Grabacion del master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		Return	
	END IF
	
else
	
	IF dw_master.Update(true, false) = -1 then		// Grabacion del master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		Return	
	END IF
	
	IF lbo_ok and idw_detail.Update(true, false) = -1 then		// Grabacion de detalle de asiento contable
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error en Grabacion Detalle de asiento","Se ha procedido al rollback",exclamation!)
		Return
	END IF
end if

if lbo_ok and ib_log then
	lbo_ok = dw_master.of_save_log()
	lbo_ok = idw_detail.of_save_log()
end if

if not lbo_ok then
	rollback;
	return
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	
	is_action = 'open'  
	f_mensaje('Grabación realizada satisfactoriamene', '')
END IF
end event

event ue_update_pre;String 	ls_origen, ls_flag_tabla, ls_cierre, ls_flag_estado, &
			ls_cuenta, ls_cencos, ls_tipo_doc, ls_nro_doc, ls_codrel, &
			ls_centro_benef, ls_flag_ctabco, ls_cod_ctabco
String 	ls_flag_cencos, ls_flag_codrel, ls_flag_doc_ref, ls_flag_centro_benef
Long 		ll_nro_libro, ll_ano, ll_mes, ll_j, ll_row, ll_nro_asiento
Decimal 	ld_debe_sol, ld_haber_sol, ld_debe_dol, ld_haber_dol

// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if dw_master.ii_update = 0 and idw_detail.ii_update = 0 then
	f_mensaje("No hay cambios que guardar, por favor verifique", "")
	return
end if

if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_detail ) <> true then return

if idw_detail.rowcount() = 0 then 
	rollback ;
	messagebox( "Atencion", "No se grabara el documento, falta detalle", StopSign!)
	return
end if

// Numeracion de documento
ls_origen 		= dw_master.object.origen			[1]
ls_flag_tabla 	= dw_master.object.flag_tabla		[1]
ls_flag_estado = dw_master.object.flag_estado	[1]
ll_nro_libro 	= Long(dw_master.object.nro_libro[1])
ll_ano 			= Long(dw_master.object.ano		[1])
ll_mes 			= Long(dw_master.object.mes		[1])


/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'M') then return

IF ls_flag_estado = '0' and is_Action <> 'anular' then
	messagebox('Asiento anulado','No se puede actualizar cambios, El asiento esta anulado')
	return
end if 

IF is_action='new' then
	IF not invo_asiento_cntbl.of_get_nro_asiento(ls_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento) THEN RETURN
	dw_master.object.nro_asiento[1] = ll_nro_asiento
else
	ll_nro_asiento = Long(dw_master.object.nro_asiento[1])
END IF

FOR ll_j = 1 to idw_detail.RowCount()
	idw_detail.object.origen 		[ll_j] = ls_origen
	idw_detail.object.ano 			[ll_j] = ll_ano
	idw_detail.object.mes 			[ll_j] = ll_mes
	idw_detail.object.nro_libro 	[ll_j] = ll_nro_libro
	idw_detail.object.nro_asiento [ll_j] = ll_nro_asiento
	idw_detail.ii_update = 1
next


// Verifica el detalle del asiento contable
if is_action <> 'anular' then
	ld_debe_sol  = 0
	ld_haber_sol = 0
	ld_debe_dol  = 0
	ld_haber_dol = 0
	
	FOR ll_j = 1 to idw_detail.RowCount()
		// Debe verificar si tiene centro de costo, codigo de relacion, documento, etc.
		ls_cuenta = idw_detail.object.cnta_ctbl[ll_j]
	
		SELECT NVL(c.flag_cencos,'0'), NVL(c.flag_doc_ref,'0'), NVL(c.flag_codrel,'0'), 
				 NVL(c.flag_centro_benef,'0'), NVL(c.flag_ctabco,'0'),
				 NVL(c.flag_estado, '0')
		  INTO :ls_flag_cencos, :ls_flag_doc_ref, :ls_flag_codrel, 
				 :ls_flag_centro_benef, :ls_flag_ctabco,
				 :ls_flag_estado
		  from cntbl_cnta c 
		 where c.cnta_ctbl=:ls_cuenta;
		 
		
		if ls_flag_estado = '0' then
			MessageBox('Error', 'La cuenta ' + ls_cuenta + ' se encuentra inactivo, por favor verifique!')
			return
		end if
		
		IF ls_flag_cencos='1' then
	
			ls_cencos = idw_detail.object.cencos[ll_j]
	
			// Verificando datos vs flag
			IF isnull(ls_cencos) OR TRIM(ls_cencos)='' then
				idw_detail.setRow(ll_j)
				idw_detail.SetColumn('cencos')
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Centro de Costo, por favor verfique!')
				Return
			END IF 
		end if
		
		IF ls_flag_centro_benef ='1' then
	
			ls_centro_benef = idw_detail.object.centro_benef[ll_j]
			
			IF isnull(ls_centro_benef) or ls_centro_benef = '' THEN
				idw_detail.ScrollToRow(ll_j)	
				idw_detail.SetColumn('centro_benef')	
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Centro de Beneficio, por favor verifique!')
				Return
			END IF
		end if
	
		IF ls_flag_ctabco ='1' then
	
			ls_cod_ctabco = idw_detail.object.cod_ctabco[ll_j]
			
			IF isnull(ls_cod_ctabco) or ls_cod_ctabco = '' THEN
				idw_detail.ScrollToRow(ll_j)	
				idw_detail.SetColumn('cod_ctabco')	
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Código de Cuenta Bancaria, por favor verifique!')
				Return
			END IF
		end if
	
		IF ls_flag_codrel ='1' then
	
			ls_codrel = idw_detail.object.cod_relacion[ll_j]
			
			IF isnull(ls_codrel) or ls_codrel = '' THEN
				idw_detail.ScrollToRow(ll_j)	
				idw_detail.SetColumn('cod_relacion')	
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Código de Relación, por favor verifique!')
				Return
			END IF
		end if
	
		IF ls_flag_doc_ref ='1' then
	
			ls_tipo_doc = idw_detail.object.tipo_docref1	[ll_j]
			ls_nro_doc 	= idw_detail.object.nro_docref1	[ll_j]
			
			IF isnull(ls_tipo_doc) or ls_tipo_doc = '' THEN
				idw_detail.ScrollToRow(ll_j)	
				idw_detail.SetColumn('tipo_docref1')	
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Documento de Referencia, por favor verifique!')
				Return
			END IF
			IF isnull(ls_nro_doc) or ls_nro_doc = '' THEN
				idw_detail.ScrollToRow(ll_j)	
				idw_detail.SetColumn('nro_docref1')	
				MessageBox('Aviso','Cuenta contable '+ls_cuenta+' exige Documento de Referencia, por favor verifique!')
				Return
			END IF
		end if
		
		IF idw_detail.object.flag_debhab[ll_j] = 'D' then
			ld_debe_sol += dec(idw_detail.object.imp_movsol[ll_j])
			ld_debe_dol += dec(idw_detail.object.imp_movdol[ll_j])
		ELSE
			ld_haber_sol += dec(idw_detail.object.imp_movsol[ll_j])
			ld_haber_dol += Dec(idw_detail.object.imp_movdol[ll_j])
		END IF
	
	NEXT
	
	IF round(ld_debe_sol,2)<>round(ld_haber_sol,2) or round(ld_debe_dol,2)<>round(ld_haber_dol,2) then
		Messagebox( "Error", "El Asiento se encuentra descuadrado, sin embargo se grabara!" &
							+ "~r~nDebe Soles: " + string(ld_debe_sol, '###,##0.00') &
							+ "~r~nHaber Soles: " + string(ld_haber_sol, '###,##0.00') &
							+ "~r~nDebe Dolares: " + string(ld_debe_dol, '###,##0.00') &
							+ "~r~nHaber Dolares: " + string(ld_haber_dol, '###,##0.00') &
							, Exclamation!)
		//Return
	END IF
	
	// Actualiza los totales
	this.of_calcula_totales( )

end if


ib_update_check = true
end event

event ue_modify;call super::ue_modify;String ls_protect

dw_master.of_protect()
idw_detail.of_protect()

if idw_detail.ii_protect = 0 then
	of_modify_dws()
end if

end event

event ue_delete_pos;call super::ue_delete_pos;IF idw_1 = dw_master THEN
	ib_estado[1] =TRUE
ELSEIF idw_1 = tab_1.tabpage_1.dw_detail THEN
	ib_estado[2] =TRUE	
ELSEIF idw_1 = tab_1.tabpage_2.dw_detdet THEN
	ib_estado[3] =TRUE
END IF
end event

event ue_print;call super::ue_print;Integer li_row
str_parametros lstr_param

if dw_master.getRow() = 0 then return
li_row = dw_master.getRow()


lstr_param.dw1 		= 'd_rpt_voucher_tbl'
lstr_param.titulo 	= 'Previo de Voucher'
lstr_param.string1 	= dw_master.object.origen [li_row]
lstr_param.integer1 	= Integer(dw_master.object.ano [li_row])
lstr_param.integer2 	= Integer(dw_master.object.mes [li_row])
lstr_param.integer3 	= Int(dw_master.object.nro_libro [li_row])
lstr_param.integer4 	= Int(dw_master.object.nro_asiento [li_row])
lstr_param.string2	= gs_empresa
lstr_param.orientacion = '1'   //Landscape
lstr_param.tipo		= '1S1I2I3I4I2S'


OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

event ue_update_Request()

sl_param.dw1 = "d_cntbl_asiento_lista_tbl"
sl_param.titulo = "Asientos contables"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4
sl_param.field_ret_i[5] = 5

// Color rojo
dw_master.modify("nro_asiento.color = 255" ) // 16777215

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param)
END IF
end event

event close;call super::close;destroy invo_asiento_cntbl
end event

type cb_saldos from commandbutton within w_cn202_asiento_contable
integer x = 2610
integer y = 52
integer width = 521
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualizar Saldos"
end type

event clicked;if MessageBox('Aviso', 'Desea realizar el proceso de Actualizacion de Saldos?, '&
							+ 'tenga en cuenta que este procedimiento puede demorar unos minutos', &
							Information!, YesNo!, 2) = 1 then
							
	invo_asiento_cntbl.of_update_asientos()
	
end if
end event

type cb_1 from commandbutton within w_cn202_asiento_contable
integer x = 2304
integer y = 52
integer width = 242
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;Long ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento, ll_count
String ls_origen
str_parametros lstr_param

// Color rojo
event ue_update_Request()

dw_master.modify("nro_asiento.color = 255" ) // 16777215

ls_origen		= sle_origen.text
ll_ano 			= long(sle_ano.text)
ll_mes 			= long(sle_mes.text)
ll_nro_libro 	= long(sle_libro.text)
ll_nro_asiento = long(sle_asiento.text)

// Refrescando el detalle
lstr_param.field_ret[1] = ls_origen
lstr_param.field_ret[2] = string(ll_ano)
lstr_param.field_ret[3] = string(ll_mes)
lstr_param.field_ret[4] = string(ll_nro_libro)
lstr_param.field_ret[5] = string(ll_nro_Asiento)

of_retrieve(lstr_param)

is_action = 'open'
end event

type sle_origen from singlelineedit within w_cn202_asiento_contable
integer x = 261
integer y = 60
integer width = 197
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_cn202_asiento_contable
integer y = 980
integer width = 3817
integer height = 900
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3781
integer height = 780
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 16711680
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 3749
integer height = 776
integer taborder = 20
string dataobject = "d_cntbl_asiento_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// Origen
ii_ck[2] = 2			// Año
ii_ck[3] = 3			// Mes
ii_ck[4] = 4			// Nro libro
ii_ck[5] = 5			// Nro asiento
ii_ck[6] = 6			// Item

ii_rk[1] = 1 	      // Origen
ii_rk[2] = 2 	      // Año
ii_rk[3] = 3 	      // Mes
ii_rk[4] = 4 	      // Nro libro
ii_rk[5] = 5 	      // Nro asiento

ii_dk[1] = 1 	      // origen
ii_dk[2] = 2 	      // año
ii_dk[3] = 3 	      // mes
ii_dk[4] = 4 	      // nro libro
ii_dk[5] = 5 	      // nro asiento


idw_mst  = dw_master


end event

event itemchanged;call super::itemchanged;String ls_flag_cencos, ls_flag_codrel, ls_filter, &
       ls_flag_ctabco, ls_flag_docref,&
		 ls_flag_estado, ls_flag_centro_benef, &
		 ls_flag_permite_mov, ls_moneda, ls_cuenta, ls_desc_cnta
Decimal ld_tasa_cambio, ld_i_soles, ld_i_dolar, ld_t_dolar, ll_count


ls_moneda = dw_master.GetItemString(dw_master.GetRow(),"cod_moneda")
ls_flag_estado = dw_master.GetItemString(dw_master.GetRow(),"flag_estado")
ld_tasa_cambio = dw_master.GetItemDecimal(dw_master.GetRow(),"tasa_cambio")

this.accepttext()

IF ls_flag_estado='0' THEN
	MessageBox('Aviso', 'Asiento se encuentra anulado no puede modificarse')
	return
END IF 

this.ii_update = 1

CHOOSE CASE dwo.name
   CASE 'cnta_ctbl'	
	  SELECT flag_cencos, flag_codrel, flag_ctabco, 
				flag_doc_ref, flag_centro_benef, 
				flag_estado, flag_permite_mov,
				desc_cnta
		 INTO :ls_flag_cencos, :ls_flag_codrel, :ls_flag_ctabco,
				:ls_flag_docref, :ls_flag_centro_benef, 
				:ls_flag_estado, :ls_flag_permite_mov,
				:ls_desc_cnta
		 FROM cntbl_cnta
		WHERE cnta_ctbl = :data;

	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Cuenta contable ' + data + ' no existe, por favor verifique!', StopSign!)
		  This.object.cnta_ctbl[row] = gnvo_app.is_null
		  return 1
	  end if
	  
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Cuenta contable ' + data + ' se encuentra anulado, por favor verifique', StopSign!)
		  This.object.cnta_ctbl[row] = gnvo_app.is_null
		  return 1
	  end if

	  this.object.desc_cnta 			[row] = ls_desc_cnta
	  this.object.flag_cencos 			[row] = ls_flag_cencos
	  this.object.flag_ctabco 			[row] = ls_flag_ctabco
	  this.object.flag_doc_ref 		[row] = ls_flag_docref
	  this.object.flag_codrel 			[row] = ls_flag_codrel
	  this.object.flag_centro_benef 	[row] = ls_flag_centro_benef

  CASE 'cencos'	

	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from centros_costo 
	  where cencos = :data ;

	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Centro de costo ' + data + ' no existe, por favor verifica')
		  This.object.cencos[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Centro de costo ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.cencos[row] = gnvo_app.is_null
		  return 1
	  end if
	  
  CASE 'centro_benef'	
	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from centro_beneficio 
	  where centro_benef = :data ;
	  
	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Centro de beneficio ' + data + ' no existe, por favor verifica')
		  This.object.centro_benef[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Centro de beneficio ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.centro_benef[row] = gnvo_app.is_null
		  return 1
	  end if
	  
  CASE 'cod_relacion'	

	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from proveedor 
	  where proveedor = :data;
	  
	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Código de Relación ' + data + ' no existe, por favor verifica')
		  This.object.cod_relacion[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Código de Relación  ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.cod_relacion[row] = gnvo_app.is_null
		  return 1
	  end if
	  	  
  CASE 'tipo_docref1'	
	  select count(*) 
	  	into :ll_count 
	  from doc_tipo 
	  where tipo_doc = :data;
	  
	  IF ll_count=0 then
		  messagebox('Aviso', 'Tipo de documento ' + data + ' no existe, por favor verifique')
		  This.object.tipo_docref1[row] = gnvo_app.is_null
		  return 1
	  end if
		 
  CASE 'imp_movsol'
	  ls_cuenta = GetItemString(row,'cnta_ctbl')
	  ld_i_soles = DEC( DATA )
     ld_t_dolar = ld_i_soles / ld_tasa_cambio
	  
	  IF ls_moneda = gnvo_app.is_soles then
     		this.object.imp_movdol [row] = ld_t_dolar
	  END IF
	  
	  //dw_detail.object.imp_movdol.protect = 0  // 1
     of_calcula_totales( )
	  
  	  ib_estado[2] = true
	  ii_update=1
			 
  CASE 'imp_movdol'
     //dw_detail.object.imp_movsol.protect = 1	  		
     //dw_detail.object.imp_movdol.protect = 0  // 1	  		
     ld_i_dolar = DEC( DATA )
	  
  	  IF ls_moneda <> gnvo_app.is_soles then
     		ld_t_dolar = ld_i_dolar * ld_tasa_cambio
	  	   this.object.imp_movsol [row] = ld_t_dolar
	  END IF
	  
	  of_calcula_totales( )
	  
  	  ib_estado[2] = true
	  ii_update=1
	  
  	CASE 'flag_debhab'
		
		of_calcula_totales( )
END CHOOSE	

end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_nro_asiento, ll_row

ll_row = dw_master.GetRow()

//Insertamos valores
this.object.nro_item				[al_row]	= of_nro_item(this)
this.object.origen 				[al_row] = dw_master.object.origen 		[ll_row]
this.object.ano 					[al_row] = dw_master.object.ano 			[ll_row]
this.object.mes 					[al_row] = dw_master.object.mes 			[ll_row]
this.object.nro_libro 			[al_row] = dw_master.object.nro_libro 	[ll_row]
this.object.fec_cntbl			[al_row] = dw_master.object.fecha_cntbl[ll_row]
this.object.flag_codrel			[al_row] = '0'
this.object.flag_ctabco			[al_row] = '0'
this.object.flag_cencos			[al_row] = '0'
this.object.flag_doc_ref		[al_row] = '0'
this.object.flag_centro_benef	[al_row] = '0'
this.object.flag_debhab			[al_row] = 'D'

if al_row > 1 Then
	this.object.det_glosa	[al_row] = this.object.det_glosa 		[al_row - 1]
	this.object.fec_cntbl	[al_row] = this.object.fec_cntbl 		[al_row - 1]
End if

of_modify_dws()




end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event type integer ue_delete_pre();call super::ue_delete_pre;ib_estado[2] = true

return 1
end event

event ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_codrel, ls_flag_docref, ls_flag_ctabco, &
			ls_flag_centro_benef, ls_flag_cencos, ls_Cod_relacion, ls_tipo_docref1

str_cnta_cntbl 	lstr_cnta			
choose case lower(as_columna)
	case "cod_ctabco"
		if this.object.flag_ctabco[al_row] = '0' then
			return
		end if
		ls_sql = "select bc.cod_ctabco as cod_ctabco, " &
				 + "b.nom_banco as descripcion_banco " &
				 + "from banco_cnta bc, " &
				 + "     banco      b " &
				 + "where bc.cod_banco =  b.cod_banco " &
			    + "  and bc.flag_estado <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_ctabco	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cencos"
		if this.object.flag_cencos[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cnta_ctbl"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta [al_row] = lstr_cnta.desc_cnta
			
			SELECT NVL(flag_cencos,'0'), NVL(flag_codrel, '0'), NVL(flag_ctabco, '0'), 
					 NVL(flag_doc_ref, '0'), NVL(flag_centro_benef, '0')
			  INTO :ls_flag_cencos, :ls_flag_codrel, :ls_flag_ctabco, 
					 :ls_flag_docref, :ls_flag_centro_benef
			  FROM cntbl_cnta
			 WHERE cnta_ctbl = :lstr_cnta.cnta_cntbl;
			
			//Activamos Petición de centro de costos
			this.object.flag_cencos 		[al_row] = ls_flag_cencos
			this.object.flag_codrel 		[al_row] = ls_flag_codrel
			this.object.flag_centro_benef [al_row] = ls_flag_centro_benef
			this.object.flag_doc_ref 		[al_row] = ls_flag_docref
			this.object.flag_ctabco 		[al_row] = ls_flag_ctabco
			
			this.ii_update = 1
		end if

	case "cod_relacion"
		if this.object.flag_codrel[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_relacion, "&
				 + "P.NOM_PROVEEDOR AS nombre_completo, "&
				 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				 + "FROM PROVEEDOR P " &
				 + "WHERE p.FLAG_ESTADO = '1'"

		if gnvo_App.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_relacion	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_docref1"
		if this.object.flag_doc_ref[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT DOC_TIPO.TIPO_DOC AS TIPO, "&
				 + "DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM DOC_TIPO "&
				 + "WHERE FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_docref1	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	CASE 'nro_docref1'
		if this.object.flag_doc_ref[al_row] = '0' then
			return
		end if
		
		ls_cod_relacion = this.object.cod_relacion [al_row]		
		IF Isnull(ls_cod_relacion) OR ls_cod_relacion = "" THEN
			Messagebox('Aviso','No se ha ingresado Codigo de relacion, por favor verifique!')
			Return 
		END IF
		
		ls_tipo_docref1 = this.object.tipo_docref1 [al_row]		
		IF Isnull(ls_tipo_docref1) OR ls_tipo_docref1 = "" THEN
			Messagebox('Aviso','No se ha ingresado Tipo de Documento, por favor verifique!')
			Return 
		END IF
		
		ls_sql = "SELECT D.TIPO_DOC AS TIPO_DOCUM    ,"&        
				 + "D.NRO_DOC		    AS NRO_DOCUM     ,"&     
				 + "d.COD_MONEDA	    AS MONEDA  ,"&
				 + "d.FLAG_DEBHAB	    AS D_H         ,"&
				 + "d.SLDO_SOL		    AS SALDO_SOLES	,"&
				 + "d.SALDO_DOL		 AS SALDO_DOLAR	,"&
				 + "d.COD_RELACION	 AS CODIGO_RELACION "&
				 + "FROM DOC_PENDIENTES_CTA_CTE  D "&
				 + "WHERE D.COD_RELACION = '" + ls_cod_relacion+"'" &
				 + "AND D.TIPO_DOC = '"+ls_tipo_docref1+"'" 
		
		if ls_codigo <> '' then
			this.object.nro_docref1	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	CASE 'centro_benef'
		if this.object.flag_centro_benef[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT CENTRO_BENEFICIO.CENTRO_BENEF AS CTRO_BENEFIC, "&
				 + "CENTRO_BENEFICIO.DESC_CENTRO AS DESCRIPCION , "&
				 + "CENTRO_BENEFICIO.COD_ORIGEN AS ORIGEN "&
				 + "FROM CENTRO_BENEFICIO "&
				 + "WHERE FLAG_ESTADO = '1'" 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

//				
//END CHOOSE
//
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type tabpage_2 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 104
integer width = 3781
integer height = 780
boolean enabled = false
long backcolor = 79741120
string text = "Auxiliar"
long tabtextcolor = 16711680
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detdet dw_detdet
end type

on tabpage_2.create
this.dw_detdet=create dw_detdet
this.Control[]={this.dw_detdet}
end on

on tabpage_2.destroy
destroy(this.dw_detdet)
end on

type dw_detdet from u_dw_abc within tabpage_2
integer width = 3255
integer height = 768
integer taborder = 20
string dataobject = "d_cntbl_asiento_det_aux_ff"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// Origen
ii_ck[2] = 2				// Año
ii_ck[3] = 3				// Mes
ii_ck[4] = 4				// Nro libro
ii_ck[5] = 5				// Nro asiento
ii_ck[6] = 6				// Item

ii_rk[1] = 1				// Origen
ii_rk[2] = 2				// Año
ii_rk[3] = 3				// Mes
ii_rk[4] = 4				// Nro libro
ii_rk[5] = 5				// Nro asiento
ii_rk[6] = 6				// Item

idw_mst  = tab_1.tabpage_1.dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event doubleclicked;call super::doubleclicked;Datawindow ldw
ldw = This
if dwo.type<>'column' THEN RETURN 1


// Ventanas de ayuda
IF Getrow() = 0 THEN Return

String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cencos'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.Setitem(row,'cencos',lstr_seleccionar.param1[1])
					this.Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'cnta_prsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					this.Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
END CHOOSE

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;String ls_origen
Integer li_ano, li_mes, li_nro_libro, li_item
Long ll_nro_asiento

//Insertamos valores
ls_origen = tab_1.tabpage_1.dw_detail.GetitemString(tab_1.tabpage_1.dw_detail.il_Row,"origen")
li_ano = tab_1.tabpage_1.dw_detail.GetitemNumber(tab_1.tabpage_1.dw_detail.il_Row,"ano")
li_mes = tab_1.tabpage_1.dw_detail.GetItemNumber(tab_1.tabpage_1.dw_detail.il_Row,"mes")
li_nro_libro = tab_1.tabpage_1.dw_detail.GetItemNumber(tab_1.tabpage_1.dw_detail.il_Row,"nro_libro")
ll_nro_asiento = tab_1.tabpage_1.dw_detail.GetItemNumber(tab_1.tabpage_1.dw_detail.il_Row,"nro_asiento")
li_item = tab_1.tabpage_1.dw_detail.GetItemNumber(tab_1.tabpage_1.dw_detail.il_Row,"item")
//ld_fec_cntbl = dw_master.GetItemDate(dw_master.il_Row,"fecha_cntbl")
THIS.Setitem(al_row,"origen",ls_origen)
THIS.Setitem(al_row,"ano",li_ano)
THIS.Setitem(al_row,"mes",li_mes)
THIS.Setitem(al_row,"nro_libro",li_nro_libro)
THIS.Setitem(al_row,"nro_asiento",ll_nro_asiento)
THIS.Setitem(al_row,"item",li_item)


end event

event itemchanged;call super::itemchanged;Integer li_count
String ls_dato, ls_descripcion

IF this.Getrow() = 0 THEN Return

CHOOSE CASE dwo.name
		 CASE 'cencos'	
				select count(*) into :li_count from centros_costo 
				where cencos = :data ;
				// Si no existe la cuenta contable
				IF li_count = 0 THEN
					Setnull(ls_dato)
					Setnull(ls_descripcion)
					Messagebox('Aviso','Centro de costo no existe, Verifique! ',StopSign!)
					This.object.cencos [row]  = ls_dato
					This.object.desc_cencos [row] = ls_descripcion
					Return 1
				ELSE
					SELECT desc_cencos
				  	INTO :ls_descripcion
				  	FROM centros_costo
				 	WHERE cencos = :data ; 
				 
				 	This.object.desc_cencos [row] = ls_descripcion
				END IF
				ib_estado[3] = true
				ii_update = 1
			
		 CASE 'cnta_prsp'
				select count(*) into :li_count from presupuesto_cuenta 
				where cnta_prsp = :data ;
				// Si no existe la cuenta presupuestal
				IF li_count = 0 THEN
					Setnull(ls_dato)
					Setnull(ls_descripcion)
					Messagebox('Aviso','Cuenta presupuestal no existe, Verifique! ',StopSign!)
					This.object.cnta_prsp [row]  = ls_dato
					This.object.descripcion [row] = ls_descripcion
					Return 1
				ELSE
					SELECT descripcion
				  	INTO :ls_descripcion
				  	FROM presupuesto_cuenta
				 	WHERE cnta_prsp = :data ; 
				 
				 	This.object.descripcion [row] = ls_descripcion
				END IF
				ib_estado[3] = true
				ii_update = 1

		 CASE 'flag_pre_cnta'
				ib_estado[3] = true
				ii_update = 1
				
END CHOOSE

end event

type dw_master from u_dw_abc within w_cn202_asiento_contable
event ue_recupera_datos ( )
integer y = 164
integer width = 4160
integer height = 796
integer taborder = 70
string dataobject = "d_cntbl_asiento_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw
ii_ck[4] = 4				// columnas de lectura de este dw
ii_ck[5] = 5				// columnas de lectura de este dw

ii_dk[1] = 1 	      	// columnas que se pasan al detalle
ii_dk[2] = 2 	      	// columnas que se pasan al detalle
ii_dk[3] = 3 	      	// columnas que se pasan al detalle
ii_dk[4] = 4 	      	// columnas que se pasan al detalle
ii_dk[5] = 5 	      	// columnas que se pasan al detalle

//idw_mst  = dw_master
idw_det  = tab_1.tabpage_1.dw_detail	// dw_detail
end event

event itemchanged;String 	ls_fecha, ls_tipo, ls_desc
Decimal 	ld_t_pr_venta, ldc_tasa_cambio
Date 		ld_fecha
Long	 	ll_comprobante
Integer 	li_ano, li_mes, li_libro, li_row

this.AcceptText()

CHOOSE CASE dwo.name
		
	case "tasa_cambio"
		ldc_tasa_cambio = Dec(this.object.tasa_cambio [row])
		
		if ldc_tasa_cambio <> 0 then
			for li_row = 1 to idw_detail.RowCount()
				idw_detail.object.imp_movdol [li_row] = dec(idw_detail.object.imp_movsol [li_row]) / ldc_tasa_cambio
				
				idw_detail.ii_update = 1
			next
		end if
		

	case "nro_libro"
		select desc_libro
			into :ls_Desc
		from cntbl_libro
		where nro_libro = :data;
		
		IF SQLCA.SQLCode = 100 then
			this.object.nro_libro 	[row] = gnvo_app.il_null
			this.object.desc_libro	[row] = gnvo_app.is_null
			MessageBox('Error', 'Nro de libro no existe, por favor verifique')
			return 1
		end if
		
		this.object.desc_libro	[row] = ls_desc
		
	CASE 'fecha_cntbl'
		accepttext()
		ld_fecha = DATE( this.object.fecha_cntbl[row] )
		
		Select usf_tipo_cambio(:ld_fecha)
		  INTO :ld_t_pr_venta
		  From DUAL;
				  
	   IF ISNULL(ld_t_pr_venta) or ld_t_pr_venta = 0 THEN
			MessageBox("Mensaje al Usuario","No existe Tipo de Cambio Promedio")			
			dw_master.object.tipo_nota.protect = 1
			dw_master.object.cod_moneda.protect = 1
			dw_master.object.desc_glosa.protect = 1
			ib_chk_fecha_cntbl = false
		ELSE
			dw_master.object.tipo_nota.protect = 0			
			dw_master.object.cod_moneda.protect = 0
			dw_master.object.desc_glosa.protect = 0
         dw_master.Setitem(row,"tasa_cambio",ld_t_pr_venta) 
			ib_chk_fecha_cntbl = true
		END IF
		ib_estado[1] = true
		ii_update=1
		of_chk()
		
	CASE 'nro_libro'
		li_libro = Integer(DATA)
		li_ano = dw_master.GetItemNumber(row,"ano")
		li_mes = dw_master.GetitemNumber(row,"mes")
	   ll_comprobante = uf_nro_asiento(li_libro,li_mes,li_ano,gs_origen)
		dw_master.Setitem(row,"nro_asiento",ll_comprobante)
		ib_estado[1] = true
		ii_update=1
		of_chk()
		
	CASE 'mes'
		li_mes = Integer(DATA)
		IF li_mes > 13 then
			messagebox('Aviso','Mes no puede ser superior a 13')
			return 1
		END IF
		ib_estado[1] = true
		ii_update=1
	CASE ELSE
		ib_estado[1] = true
		ii_update=1
END CHOOSE		
end event

event ue_insert_pre;call super::ue_insert_pre;Decimal 	ldc_tasa_cambio
DateTime	ldt_now
DAte		ld_fec_cntbl 

ldt_now 		= gnvo_app.of_fecha_actual()
ld_fec_cntbl = Date(ldt_now)

Select usf_cnt_tipo_cambio(:ld_fec_cntbl)
  INTO :ldc_tasa_cambio
  From DUAL;

this.object.fec_registro	[al_row] = ldt_now

//Cargamos Datos iniciales de configuración
dw_master.object.cod_usr 		[al_row] = gs_user
dw_master.object.origen 		[al_row] = gs_origen
dw_master.object.fecha_cntbl 	[al_row] = ld_fec_cntbl
dw_master.object.ano 			[al_row] = year(ld_fec_cntbl)
dw_master.object.mes 			[al_row] = MONTH(ld_fec_cntbl)
dw_master.object.flag_tabla 	[al_row] = "V"
dw_master.object.flag_estado 	[al_row] = "1"
dw_master.object.tasa_cambio 	[al_row] = ldc_tasa_cambio



of_chk()
//is_accion = 'new'
is_action = 'new'

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
	case "nro_libro"
		ls_sql = "SELECT nro_libro AS numero_libro, " &
				  + "desc_libro AS descripcion_libro " &
				  + "FROM cntbl_libro " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.nro_libro	[al_row] = Long(ls_codigo)
			this.object.desc_libro	[al_row] = ls_data
			this.ii_update = 1
		end if
		

end choose
end event

type sle_ano from singlelineedit within w_cn202_asiento_contable
integer x = 631
integer y = 60
integer width = 197
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_cn202_asiento_contable
integer x = 1408
integer y = 60
integer width = 197
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn202_asiento_contable
integer x = 1006
integer y = 60
integer width = 197
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_asiento from singlelineedit within w_cn202_asiento_contable
integer x = 1842
integer y = 60
integer width = 334
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn202_asiento_contable
integer x = 59
integer y = 60
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn202_asiento_contable
integer x = 494
integer y = 60
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn202_asiento_contable
integer x = 864
integer y = 60
integer width = 137
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn202_asiento_contable
integer x = 1234
integer y = 60
integer width = 155
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_5 from statictext within w_cn202_asiento_contable
integer x = 1632
integer y = 60
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Asiento"
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn202_asiento_contable
integer width = 2597
integer height = 156
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Datos de Búsqueda "
borderstyle borderstyle = styleraised!
end type

