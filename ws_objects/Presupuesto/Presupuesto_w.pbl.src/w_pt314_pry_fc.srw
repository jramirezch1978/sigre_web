$PBExportHeader$w_pt314_pry_fc.srw
forward
global type w_pt314_pry_fc from w_abc
end type
type dw_periodos from datawindow within w_pt314_pry_fc
end type
type dw_it_fc_del from datawindow within w_pt314_pry_fc
end type
type dw_it_frm_del from datawindow within w_pt314_pry_fc
end type
type dw_result from datawindow within w_pt314_pry_fc
end type
type tab_fc from tab within w_pt314_pry_fc
end type
type tabpage_be from userobject within tab_fc
end type
type st_1 from statictext within tabpage_be
end type
type dw_be from u_dw_abc within tabpage_be
end type
type dw_bed from u_dw_abc within tabpage_be
end type
type tabpage_be from userobject within tab_fc
st_1 st_1
dw_be dw_be
dw_bed dw_bed
end type
type tabpage_in from userobject within tab_fc
end type
type dw_in from u_dw_abc within tabpage_in
end type
type tabpage_in from userobject within tab_fc
dw_in dw_in
end type
type tabpage_cf from userobject within tab_fc
end type
type dw_cf from u_dw_abc within tabpage_cf
end type
type tabpage_cf from userobject within tab_fc
dw_cf dw_cf
end type
type tabpage_cv from userobject within tab_fc
end type
type dw_cv from u_dw_abc within tabpage_cv
end type
type tabpage_cv from userobject within tab_fc
dw_cv dw_cv
end type
type tabpage_lc from userobject within tab_fc
end type
type dw_lc from u_dw_abc within tabpage_lc
end type
type tabpage_lc from userobject within tab_fc
dw_lc dw_lc
end type
type tabpage_im from userobject within tab_fc
end type
type dw_im from u_dw_abc within tabpage_im
end type
type tabpage_im from userobject within tab_fc
dw_im dw_im
end type
type tabpage_mfc from userobject within tab_fc
end type
type dw_mfc from u_dw_abc within tabpage_mfc
end type
type tabpage_mfc from userobject within tab_fc
dw_mfc dw_mfc
end type
type tab_fc from tab within w_pt314_pry_fc
tabpage_be tabpage_be
tabpage_in tabpage_in
tabpage_cf tabpage_cf
tabpage_cv tabpage_cv
tabpage_lc tabpage_lc
tabpage_im tabpage_im
tabpage_mfc tabpage_mfc
end type
type dw_pry from u_dw_abc within w_pt314_pry_fc
end type
end forward

global type w_pt314_pry_fc from w_abc
integer width = 3858
integer height = 2120
string title = "Proyecto - Flujo Caja (PT314)"
string menuname = "m_mantenimiento_cl"
dw_periodos dw_periodos
dw_it_fc_del dw_it_fc_del
dw_it_frm_del dw_it_frm_del
dw_result dw_result
tab_fc tab_fc
dw_pry dw_pry
end type
global w_pt314_pry_fc w_pt314_pry_fc

type variables
String is_tipcst_mo, is_tip_cst_equipo, is_tipcst_material,&
		 is_tipcst_servicio, is_tipcst_otro
String is_tipfc_beneficio, is_tipfc_inversion, is_tipfc_amortizacion,&
		 is_tipfc_cfijo, is_tipfc_cvar, is_tipfc_lcred, is_tipfc_impuesto
		 
DataWindow idw_be, idw_bed, idw_cf, idw_cv, idw_in, idw_im, idw_lc, idw_mfc
end variables

forward prototypes
public subroutine wf_retrieve_beneficio_def (string as_nro_pry, long al_itm_fc)
public subroutine wf_act_matriz_bed (integer ai_meses)
public function string wf_act_formula (string as_formula_old, integer ai_row, string as_accion)
public subroutine wf_evalua_formula ()
public subroutine wf_retrieve_fc (string as_nro_pry, string as_rubro, datawindow adw_1)
public subroutine wf_act_matriz_fc (integer ai_meses, datawindow adw_1)
public function integer wf_update_fc (string as_nro_pry, integer ai_meses, datawindow adw_1)
public subroutine wf_retrieve_matriz_fc (string as_nro_pry)
public subroutine wf_retrieve_periodos (string as_nro_pry)
public function string wf_desc_periodo (integer ai_mes)
end prototypes

public subroutine wf_retrieve_beneficio_def (string as_nro_pry, long al_itm_fc);string  ls_select
string  ls_where
string  ls_dwsyntax
string  ls_err
String  ls_report_type, ls_type_font, ls_style
Integer li_mes, li_i
Date 	  ld_fecha_ini
String 	ls_ColName[], ls_ColName_t[], ls_x[]
Integer li_numcols, li_totfilas
String ls_col, ls_col_t, ls_desc_periodo
Long ll_tabseq

Select fecha_inicio_proy, nro_meses_eval into :ld_fecha_ini, :li_mes
from proyecto where nro_proyecto = :as_nro_pry;

//Recupero dw Resultado
dw_result.DataObject = "d_lis_pry_fc_det_frm_mes"
dw_result.SetTransObject(sqlca)
dw_result.Retrieve(as_nro_pry, al_itm_fc)

//Construccion del SQLSelect
ls_select = "Select nro_item_frm, fila, descripcion, flag_formula, formula, flag_resultado"

For li_i = 1 to li_mes
	ls_select = ls_select + ",0 as M"+Right("00"+String(li_i),3)
Next
ls_select = ls_select +" from pry_fc_det_frm "&
							 +"where nro_proyecto = '"+as_nro_pry+"' "&
							 +"and nro_item_fc = "+String(al_itm_fc)+" order by fila"

//Creacion Dw Dinamico
ls_report_type  = "grid"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=6 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) ' 
			  

ls_dwsyntax = SQLCA.SyntaxFromSQL ( ls_select, ls_style, ls_err )
idw_bed.Create ( ls_dwsyntax, ls_err )
IF ls_err <> '' THEN
	MessageBox ( "error - Syntax", ls_err )
ELSE
	idw_bed.SetTransObject ( SQLCA )
	idw_bed.Retrieve()
end if

//Formato General
idw_bed.Object.DataWindow.Selected.Mouse='No'
idw_bed.Object.DataWindow.Retrieve.AsNeeded='Yes'
idw_bed.Object.DataWindow.Grid.ColumnMove = 'no'
idw_bed.Object.DataWindow.Header.Height = 66
idw_bed.Object.DataWindow.Detail.Height = 60

//TabSequence
li_NumCols = Integer(idw_bed.Describe("Datawindow.Column.Count"))
ll_tabseq = 0
FOR li_i = 1 TO li_NumCols
	ls_ColName  [li_i] = idw_bed.Describe("#"+String(li_i)+".Name")
	ls_ColName_t[li_i] = ls_ColName[li_i]+'_t'
	ll_tabseq = ll_tabseq + 10
	idw_bed.Modify(ls_ColName[li_i]+".tabsequence="+String(ll_tabseq))
NEXT
idw_bed.Object.flag_resultado.tabsequence = 0
idw_bed.Object.fila.tabsequence = 0

//Ocultar columna nro_item_frm
idw_bed.Modify(ls_ColName[1]+".visible=0" + ls_ColName[1]+".Width=0")

//Etiquetas de la cabecera
idw_bed.Modify(ls_ColName_t[2]+".text='Fila' ")
idw_bed.Modify(ls_ColName_t[4]+".text='F?' ")

//Formato Detalle
idw_bed.Modify(ls_ColName[2]+".width=80")// Nro Fila
idw_bed.Modify(ls_ColName[3]+".width=800")// Descripcion
idw_bed.Modify(ls_ColName[4]+".width=80 "+ls_ColName[4]+".checkbox.text='' "+ls_ColName[4]+".checkbox.on='1' "+ls_ColName[4]+".checkbox.off='0' "+ls_ColName[4]+".checkbox.scale= yes "+ls_ColName[4]+".checkbox.threed= yes ")// Flag Formula
idw_bed.Modify(ls_ColName[5]+".width=800 "+ls_ColName[5]+".protect='0~tif( integer(flag_formula) =1,0,1)' ")// Formula
//idw_bed.Modify(ls_ColName[6]+".width=180 "+ls_ColName[6]+".values='Línea Crédito	1/Amortizacion	0/' "+ls_ColName[6]+".ddlb.limit=0 "+ls_ColName[6]+".ddlb.allowedit=no "+ls_ColName[6]+".ddlb.vscrollbar=yes "+ls_ColName[6]+".ddlb.useasborder=yes "+ls_ColName[6]+".ddlb.imemode=0")// Flag Resultado
idw_bed.Modify(ls_ColName[6]+".width=80 "+ls_ColName[6]+".checkbox.text='' "+ls_ColName[6]+".checkbox.on='1' "+ls_ColName[6]+".checkbox.off='0' "+ls_ColName[6]+".checkbox.scale= yes "+ls_ColName[6]+".checkbox.threed= yes ")// Flag Resultado
//Formato Detalle (meses)
For li_i = 1 to li_mes
	ls_col = "M"+Right("00"+String(li_i),3)
	ls_col_t = ls_col+"_t"
	ls_desc_periodo = wf_desc_periodo(li_i)
	idw_bed.Modify(ls_Col_t+".text='"+ls_desc_periodo+"' ")
	idw_bed.Modify(ls_Col+".width=300 "+ls_Col+".format='###,###.00' "+ls_Col+".alignment='1' "+ls_Col+".protect='0~tif( integer(flag_formula) =1,1,0)' ")//+ls_Col+".font.face='Arial Narrow'"+ls_Col+".font.height='-8' "+ls_Col+".font.weight='400' "+ls_Col+".font.family='2' "+ls_Col+".font.pitch='2' "+ls_Col+".font.charset='0'")	
Next

//Actualizar Matriz de la Definicion del Beneficio
wf_act_matriz_bed(li_mes)

idw_bed.Settransobject(SQLCA)
idw_bed.visible = true
setpointer(Arrow!)
end subroutine

public subroutine wf_act_matriz_bed (integer ai_meses);Integer li_i, li_TotMeses, li_j,li_TotFilas, li_TotResultado
String  ls_find
Long 	  ll_find, ll_itm_frm
Decimal ln_valor
String  ls_mes

li_TotMeses 	 = ai_meses
li_TotFilas 	 = idw_bed.RowCount()
li_TotResultado = dw_result.RowCount()

For li_i = 1 to li_TotMeses
	ls_mes = "M"+Right("00"+String(li_i),3)
	For li_j = 1 to li_TotFilas
		ll_itm_frm = idw_bed.GetItemNumber(li_j,"nro_item_frm")
		ls_find 	  = "nro_item_frm = "+String(ll_itm_frm)+" AND mes ="+String(li_i)
		ll_find 	  = dw_result.Find(ls_find,1,li_TotResultado)

		If ll_find > 0 then
			ln_valor = dw_result.GetItemNumber(ll_find,"valor")
			idw_bed.SetItem(li_j,ls_mes,ln_valor)			
		end if
		ll_find = 0
	next
next
end subroutine

public function string wf_act_formula (string as_formula_old, integer ai_row, string as_accion);//as_formula_old: la formula antigua
//ai_row indica el numero de fila a partir del cual debe actualizar
//as_accion: 'I'= Insertar, 'D'=Delete
//los parametros que incluyen filas: [FXX]
//la funcion retorna la formula modificada por el efectos de
//insertar filas en el dw

String ls_cadena, ls_fila
Integer li_start, li_pos
ls_cadena = as_formula_old

li_start = 1

Do while Pos(ls_cadena,'[F',li_start)>0
	li_pos = Pos(ls_cadena,'[F',li_start)
	ls_fila = Mid(ls_cadena,li_pos+2,2)
	If Integer(ls_fila)>=ai_row then
		If as_accion = 'I' then
			ls_cadena = Replace(ls_cadena,li_pos+2,2,Right('0'+String(Integer(ls_fila)+1),2))
		elseif as_accion = 'D' then
			ls_cadena = Replace(ls_cadena,li_pos+2,2,Right('0'+String(Integer(ls_fila)-1),2))
		end if
	end if
	li_start = li_pos + 5
Loop

Return ls_cadena
end function

public subroutine wf_evalua_formula ();Integer li_i, li_start, li_pos, li_TotMeses, li_j
String ls_cad, ls_formula,ls_fila,ls_valor, ls_desc_periodo
Decimal lde_result
n_cst_evaluate ids_1
		
ids_1 = create n_cst_evaluate
li_TotMeses = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]

For li_i=1 to idw_bed.RowCount()
	If idw_bed.GetItemString(li_i,"flag_formula") = '1' then
		ls_formula = idw_bed.GetItemString(li_i,"formula")
		For li_j = 1 to li_TotMeses
			ls_cad = ls_formula
			ls_desc_periodo = "M"+Right("00"+String(li_j),3)
			li_start = 1
			Do while Pos(ls_cad,'[F',li_start)>0
				
				li_pos = Pos(ls_cad,'[F',li_start)
				ls_fila = Mid(ls_cad,li_pos+2,2)
				ls_valor = String(idw_bed.GetItemNumber(Integer(ls_fila),ls_desc_periodo))
				
				ls_cad = Replace(ls_cad,li_pos,5,ls_valor)
				
				li_start = li_pos + len(ls_valor)
			Loop
			lde_result = Double( ids_1.of_evaluate( ls_cad))
			idw_bed.SetItem(li_i, ls_desc_periodo, lde_result)
		next
	end if
next
end subroutine

public subroutine wf_retrieve_fc (string as_nro_pry, string as_rubro, datawindow adw_1);string  ls_select
string  ls_where
string  ls_dwsyntax
string  ls_err
String  ls_report_type, ls_type_font, ls_style
Integer li_mes, li_i
Date 	  ld_fecha_ini
String 	ls_ColName[], ls_ColName_t[], ls_x[]
Integer li_numcols, li_totfilas
String ls_col, ls_col_t, ls_desc_periodo, ls_rubro[2]
Long ll_tabseq

Select fecha_inicio_proy, nro_meses_eval into :ld_fecha_ini, :li_mes
from proyecto where nro_proyecto = :as_nro_pry;

//Recupero dw Resultado
dw_result.DataObject = "d_lis_pry_fc_det_mes_x_rubro"
dw_result.SetTransObject(sqlca)
//
SetNull(ls_rubro[1])
SetNull(ls_rubro[2])

if as_rubro = is_tipfc_lcred then
	ls_rubro[1] = is_tipfc_lcred
	ls_rubro[2] = is_tipfc_amortizacion
else
	ls_rubro[1] = as_rubro
end if
dw_result.Retrieve(as_nro_pry,ls_rubro)

//Nota: Linea de Credito maneja dos rubros:
//is_tipfc_lcred -> Linea de Credito propiamente dicho
//is_tipfc_amortizacion -> Amortizacion del credito

//Construccion del SQLSelect
ls_select = "Select nro_item_fc, fila, rubro_fc, descripcion"

For li_i = 1 to li_mes
	ls_select = ls_select + ",0 as M"+Right("00"+String(li_i),3)
Next

If as_rubro = is_tipfc_lcred then//Linea de Credito
	ls_select = ls_select +" from pry_fc_det "&
								 +"where nro_proyecto = '"+as_nro_pry+"' "&
								 +"and rubro_fc in ('"+is_tipfc_lcred+"','"+is_tipfc_amortizacion+"')"
else
	ls_select = ls_select +" from pry_fc_det "&
								 +"where nro_proyecto = '"+as_nro_pry+"' "&
								 +"and rubro_fc = '"+as_rubro+"'"
end if

//Creacion Dw Dinamico
ls_report_type  = "grid"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=6 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) ' 
			  

ls_dwsyntax = SQLCA.SyntaxFromSQL ( ls_select, ls_style, ls_err )
adw_1.Create ( ls_dwsyntax, ls_err )
IF ls_err <> '' THEN
	MessageBox ( "error - Syntax", ls_err )
ELSE
	adw_1.SetTransObject ( SQLCA )
	adw_1.Retrieve()
end if

//Formato General
adw_1.Object.DataWindow.Selected.Mouse='No'
adw_1.Object.DataWindow.Retrieve.AsNeeded='Yes'
adw_1.Object.DataWindow.Grid.ColumnMove = 'no'
adw_1.Object.DataWindow.Header.Height = 66
adw_1.Object.DataWindow.Detail.Height = 60

//TabSequence
li_NumCols = Integer(adw_1.Describe("Datawindow.Column.Count"))
ll_tabseq = 0
FOR li_i = 1 TO li_NumCols
	ls_ColName  [li_i] = adw_1.Describe("#"+String(li_i)+".Name")
	ls_ColName_t[li_i] = ls_ColName[li_i]+'_t'
	ll_tabseq = ll_tabseq + 10
	adw_1.Modify(ls_ColName[li_i]+".tabsequence="+String(ll_tabseq))
NEXT
adw_1.Object.fila.tabsequence = 0

//Etiquetas de la cabecera
adw_1.Modify(ls_ColName_t[2]+".text='Fila' ")
adw_1.Modify(ls_ColName_t[3]+".text='Tip' ")

//Formato Detalle
adw_1.Modify(ls_ColName[2]+".width=80")// Nro Fila
//adw_1.Modify(ls_ColName[3]+".width=250 "+ls_ColName[3]+".values='Línea Crédito   "+is_tipfc_lcred+"/Amortizacion   "+is_tipfc_amortizacion+"/' "+ls_ColName[3]+".ddlb.limit=0 "+ls_ColName[3]+".ddlb.allowedit=no "+ls_ColName[3]+".ddlb.vscrollbar=yes "+ls_ColName[3]+".ddlb.useasborder=yes "+ls_ColName[3]+".ddlb.imemode=0")// Rubro FC
adw_1.Modify(ls_ColName[3]+".width=180 "+ls_ColName[3]+".initial ='LC' "+ls_ColName[3]+".values='Línea Crédito	LC/Amortizacion	AM/' "+ls_ColName[3]+".ddlb.limit=0 "+ls_ColName[3]+".ddlb.allowedit=no "+ls_ColName[3]+".ddlb.vscrollbar=yes "+ls_ColName[3]+".ddlb.useasborder=yes "+ls_ColName[3]+".ddlb.imemode=0")// Flag Resultado

adw_1.Modify(ls_ColName[4]+".width=800 ")//Descripcion

//Ocultar columna nro_item_fc
adw_1.Modify(ls_ColName[1]+".visible=0" + ls_ColName[1]+".Width=0")
If as_rubro <> is_tipfc_lcred then//!Linea de Credito
	adw_1.Modify(ls_ColName[3]+".visible=0" + ls_ColName[3]+".Width=0")
end if

//Formato Detalle (meses)
For li_i = 1 to li_mes
	ls_col = "M"+Right("00"+String(li_i),3)
	ls_col_t = ls_col+"_t"
	ls_desc_periodo = wf_desc_periodo(li_i)
	adw_1.Modify(ls_Col_t+".text='"+ls_desc_periodo+"' ")
	adw_1.Modify(ls_Col+".width=300 "+ls_Col+".format='###,###.00' "+ls_Col+".alignment='1' "+ls_Col+".protect='0~tif( integer(flag_formula) =1,1,0)' ")//+ls_Col+".font.face='Arial Narrow'"+ls_Col+".font.height='-8' "+ls_Col+".font.weight='400' "+ls_Col+".font.family='2' "+ls_Col+".font.pitch='2' "+ls_Col+".font.charset='0'")	
Next

//Actualizar Matriz de la Definicion del Beneficio
wf_act_matriz_fc(li_mes,adw_1)

adw_1.Settransobject(SQLCA)
adw_1.visible = true
setpointer(Arrow!)
end subroutine

public subroutine wf_act_matriz_fc (integer ai_meses, datawindow adw_1);Integer li_i, li_TotMeses, li_j,li_TotFilas, li_TotResultado
String  ls_find
Long 	  ll_find, ll_itm_fc
Decimal ln_valor
String  ls_mes

li_TotMeses 	 = ai_meses
li_TotFilas 	 = adw_1.RowCount()
li_TotResultado = dw_result.RowCount()

For li_i = 1 to li_TotMeses
	ls_mes = "M"+Right("00"+String(li_i),3)
	For li_j = 1 to li_TotFilas
		ll_itm_fc  = adw_1.GetItemNumber(li_j,"nro_item_fc")
		ls_find 	  = "nro_item_fc = "+String(ll_itm_fc)+" AND mes ="+String(li_i)
		ll_find 	  = dw_result.Find(ls_find,1,li_TotResultado)

		If ll_find > 0 then
			ln_valor = dw_result.GetItemNumber(ll_find,"valor")
			adw_1.SetItem(li_j,ls_mes,ln_valor)			
		end if
		ll_find = 0
	next
next
end subroutine

public function integer wf_update_fc (string as_nro_pry, integer ai_meses, datawindow adw_1);Long ll_max_itm_fc, ll_itm_fc,ll_itm_fc_aux, ll_fila
String ls_descripcion, ls_desc_periodo, ls_rubro
Integer li_i, li_j, li_count
Decimal ln_valor

Select nvl(max(nro_item_fc),0) into :ll_max_itm_fc
  from pry_fc_det
 where nro_proyecto = :as_nro_pry;

If f_valida_transaccion(sqlca) = False then GoTo error_bd

ll_itm_fc = ll_max_itm_fc
For li_i = 1 to adw_1.RowCount()
	ll_itm_fc_aux = adw_1.GetItemNumber(li_i,"nro_item_fc")
	ll_fila 			= adw_1.GetItemNumber(li_i,"fila")
	ls_descripcion = adw_1.GetItemString(li_i,"descripcion")
	ls_rubro     = adw_1.GetItemString(li_i,"rubro_fc")
	
	If IsNull(ll_itm_fc_aux) or ll_itm_fc_aux <=0 then//Nuevo
		ll_itm_fc = ll_itm_fc+ 1
		adw_1.SetItem(li_i,"nro_item_fc",ll_itm_fc)
		
		Insert into pry_fc_det(nro_proyecto, nro_item_fc, fila, rubro_fc, descripcion, cod_usr,
		observaciones, flag_replicacion)
		values(:as_nro_pry, :ll_itm_fc, :ll_fila, :ls_rubro, :ls_descripcion, :gs_user,
				 null,'1');
		If f_valida_transaccion(sqlca) = False then 
			MessageBox("","error1")
			GoTo error_bd
		end if
		For li_j = 1 to ai_meses
			ls_desc_periodo = "M"+Right("00"+String(li_j),3)
			ln_valor = adw_1.GetItemNumber(li_i,ls_desc_periodo)
			Insert into pry_fc_det_mes(nro_proyecto, nro_item_fc, mes, valor, cod_usr, flag_replicacion)
			values(:as_nro_pry, :ll_itm_fc, :li_j, :ln_valor, :gs_user, '1');
			If f_valida_transaccion(sqlca) = False then 
				MessageBox("","error2")
				GoTo error_bd
			end if
		next		
	else//Ya Existe: Actualizar
		Update pry_fc_det
			set descripcion = :ls_descripcion,
				 fila = :ll_fila
		 where nro_proyecto = :as_nro_pry
			and nro_item_fc = :ll_itm_fc_aux;
			
		If f_valida_transaccion(sqlca) = False then 
			MessageBox("","error22")
			GoTo error_bd
		end if

		For li_j = 1 to ai_meses
			ls_desc_periodo = "M"+Right("00"+String(li_j),3)
			ln_valor = adw_1.GetItemNumber(li_i,ls_desc_periodo)
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
			
			Select count(*) into :li_count
			  from pry_fc_det_mes
			 where nro_proyecto = :as_nro_pry
			   and nro_item_fc = :ll_itm_fc_aux
				and mes = :li_j;
			
			If li_count = 0 then
				Insert into pry_fc_det_mes(nro_proyecto, nro_item_fc, mes, valor, cod_usr, flag_replicacion)
				values(:as_nro_pry, :ll_itm_fc_aux, :li_j, :ln_valor, :gs_user, '1');
				If f_valida_transaccion(sqlca) = False then 
					MessageBox("","Error4")
					GoTo error_bd
				end if
			elseif li_count = 1 then
				Update pry_fc_det_mes
					set valor = :ln_valor
				 where nro_proyecto = :as_nro_pry
					and nro_item_fc = :ll_itm_fc_aux
					and mes = :li_j;
				If f_valida_transaccion(sqlca) = False then 
					MessageBox("","Error5")
					GoTo error_bd
				end if
			end if
		next
	end if
next
Return 0
error_bd:
Rollback;
Return -1
end function

public subroutine wf_retrieve_matriz_fc (string as_nro_pry);string  ls_select
string  ls_where
string  ls_dwsyntax
string  ls_err
String  ls_report_type, ls_type_font, ls_style
Integer li_mes, li_i
Date 	  ld_fecha_ini
String 	ls_ColName[], ls_ColName_t[], ls_x[]
Integer li_numcols, li_totfilas
String ls_col, ls_col_t, ls_desc_periodo, ls_rubro[2]
Integer li_TotMeses, li_j, li_TotResultado
String  ls_find, ls_rubro_fc
Long 	  ll_find
Decimal ln_valor
String  ls_mes

Select fecha_inicio_proy, nro_meses_eval into :ld_fecha_ini, :li_mes
from proyecto where nro_proyecto = :as_nro_pry;

//Recupero dw Resultado
dw_result.DataObject = "d_lis_pry_matriz_fc"
dw_result.SetTransObject(sqlca)
//
sqlca.AutoCommit = True;
DECLARE PB_GENERA_FC &
PROCEDURE FOR USP_PRY_GENERA_FC(:as_nro_pry) ;
execute PB_GENERA_FC ;

IF sqlca.sqlcode = -1 THEN
  rollback ;
  MessageBox( 'Error usp_pry_genera_fc', sqlca.sqlerrtext, StopSign! )
  Return
END IF
dw_result.Retrieve()

//Construccion del SQLSelect
ls_select = "Select rubro_fc, desc_rubro_fc"

For li_i = 1 to li_mes
	ls_select = ls_select + ",0 as M"+Right("00"+String(li_i),3)
Next


ls_select = ls_select +" from tt_pry_fc_rubro order by nro_fila"

//Creacion Dw Dinamico
ls_report_type  = "grid"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=6 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) '

ls_dwsyntax = SQLCA.SyntaxFromSQL ( ls_select, ls_style, ls_err )
idw_mfc.Create ( ls_dwsyntax, ls_err )
IF ls_err <> '' THEN
	MessageBox ( "error - Syntax", ls_err )
ELSE
	idw_mfc.SetTransObject ( SQLCA )
	idw_mfc.Retrieve()
end if
sqlca.AutoCommit = False;

//Formato General
idw_mfc.Object.DataWindow.Selected.Mouse='No'
idw_mfc.Object.DataWindow.Retrieve.AsNeeded='Yes'
idw_mfc.Object.DataWindow.Grid.ColumnMove = 'no'
idw_mfc.Object.DataWindow.Header.Height = 66
idw_mfc.Object.DataWindow.Detail.Height = 60

//Recuperar Nombres de Columnas
li_NumCols = Integer(idw_mfc.Describe("Datawindow.Column.Count"))
FOR li_i = 1 TO li_NumCols
	ls_ColName  [li_i] = idw_mfc.Describe("#"+String(li_i)+".Name")
	ls_ColName_t[li_i] = ls_ColName[li_i]+'_t'
NEXT

//Etiquetas de la cabecera
idw_mfc.Modify(ls_ColName_t[2]+".text='' ")

//Formato Detalle
idw_mfc.Modify(ls_ColName[2]+".width=800")// Desc Rubro Flujo Caja

//Ocultar columna rubro_fc
idw_mfc.Modify(ls_ColName[1]+".visible=0" + ls_ColName[1]+".Width=0")

//Formato Detalle (meses)
For li_i = 1 to li_mes
	ls_col = "M"+Right("00"+String(li_i),3)
	ls_col_t = ls_col+"_t"
	ls_desc_periodo = wf_desc_periodo(li_i)
	idw_mfc.Modify(ls_Col_t+".text='"+ls_desc_periodo+"' ")
	idw_mfc.Modify(ls_Col+".width=300 "+ls_Col+".format='###,###.00' "+ls_Col+".alignment='1' "+ls_Col+".protect='0~tif( integer(flag_formula) =1,1,0)' ")//+ls_Col+".font.face='Arial Narrow'"+ls_Col+".font.height='-8' "+ls_Col+".font.weight='400' "+ls_Col+".font.family='2' "+ls_Col+".font.pitch='2' "+ls_Col+".font.charset='0'")	
Next

//Actualizar Matriz del Flujo de Caja
li_TotMeses 	 = li_mes
li_TotFilas 	 = idw_mfc.RowCount()
li_TotResultado = dw_result.RowCount()

For li_i = 1 to li_TotMeses
	ls_mes = "M"+Right("00"+String(li_i),3)
	For li_j = 1 to li_TotFilas
		ls_rubro_fc  = idw_mfc.GetItemString(li_j,"rubro_fc")
		ls_find 	  = "rubro_fc = '"+ls_rubro_fc+"' AND periodo ="+String(li_i)
		ll_find 	  = dw_result.Find(ls_find,1,li_TotResultado)
		If ll_find > 0 then
			ln_valor = dw_result.GetItemNumber(ll_find,"valor")
			idw_mfc.SetItem(li_j,ls_mes,ln_valor)			
		end if
		ll_find = 0
	next
next

//
idw_mfc.Settransobject(SQLCA)
idw_mfc.visible = true
setpointer(Arrow!)
end subroutine

public subroutine wf_retrieve_periodos (string as_nro_pry);Date ld_fec_ini
Integer li_TotMeses, li_ano, li_mes, li_i, li_row
String ls_mes

Select fecha_inicio_proy, nro_meses_eval
  into :ld_fec_ini, :li_TotMeses
  from proyecto
 where nro_proyecto = :as_nro_pry;

li_ano = Year(ld_fec_ini)
li_mes = Month(ld_fec_ini)

For li_i = 1 to li_TotMeses
	Choose Case li_mes
		Case 1
			ls_mes = 'ENE'
		Case 2
			ls_mes = 'FEB'
		Case 3
			ls_mes = 'MAR'
		Case 4
			ls_mes = 'ABR'
		Case 5
			ls_mes = 'MAY'
		Case 6
			ls_mes = 'JUN'
		Case 7
			ls_mes = 'JUL'
		Case 8
			ls_mes = 'AGO'
		Case 9
			ls_mes = 'SET'
		Case 10
			ls_mes = 'OCT'
		Case 11
			ls_mes = 'NOV'
		Case 12
			ls_mes = 'DIC'
	end choose
	li_row = dw_periodos.InsertRow(0)
	dw_periodos.Object.mes[li_row] = li_i
	dw_periodos.Object.desc_mes[li_row] = ls_mes+" "+String(li_ano)
	If li_mes + 1 = 13 then
		li_mes = 1
		li_ano = li_ano + 1
	else
		li_mes = li_mes + 1
	end if
Next
end subroutine

public function string wf_desc_periodo (integer ai_mes);Integer li_find
String ls_desc
li_find = dw_periodos.Find("mes ="+String(ai_mes),1, dw_periodos.RowCount())
if li_find > 0 then
	ls_desc = dw_periodos.Object.desc_mes[li_find]
end if
Return ls_desc
end function

on w_pt314_pry_fc.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.dw_periodos=create dw_periodos
this.dw_it_fc_del=create dw_it_fc_del
this.dw_it_frm_del=create dw_it_frm_del
this.dw_result=create dw_result
this.tab_fc=create tab_fc
this.dw_pry=create dw_pry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_periodos
this.Control[iCurrent+2]=this.dw_it_fc_del
this.Control[iCurrent+3]=this.dw_it_frm_del
this.Control[iCurrent+4]=this.dw_result
this.Control[iCurrent+5]=this.tab_fc
this.Control[iCurrent+6]=this.dw_pry
end on

on w_pt314_pry_fc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_periodos)
destroy(this.dw_it_fc_del)
destroy(this.dw_it_frm_del)
destroy(this.dw_result)
destroy(this.tab_fc)
destroy(this.dw_pry)
end on

event ue_open_pre;call super::ue_open_pre;//Valores de los parametros
select tipo_gasto_mo      , tipo_gasto_equipo  , tipo_gasto_material,
		 tipo_gasto_servicio, tipo_gasto_otro    ,
		 tipo_fc_beneficio  , tipo_fc_inversion  , tipo_fc_amortizacion,
		 tipo_fc_costo_fijo , tipo_fc_costo_var  , tipo_fc_linea_cred
  into :is_tipcst_mo      , :is_tip_cst_equipo , :is_tipcst_material,
		 :is_tipcst_servicio, :is_tipcst_otro    ,
		 :is_tipfc_beneficio, :is_tipfc_inversion, :is_tipfc_amortizacion,
		 :is_tipfc_cfijo    , :is_tipfc_cvar     , :is_tipfc_lcred
  from pry_param
 where reckey = '1';

is_tipfc_impuesto = "IM"

idw_be  = tab_fc.tabpage_be.dw_be
idw_bed = tab_fc.tabpage_be.dw_bed
idw_in  = tab_fc.tabpage_in.dw_in
idw_cf  = tab_fc.tabpage_cf.dw_cf
idw_cv  = tab_fc.tabpage_cv.dw_cv
idw_im  = tab_fc.tabpage_im.dw_im
idw_lc  = tab_fc.tabpage_lc.dw_lc
idw_mfc = tab_fc.tabpage_mfc.dw_mfc

idw_1 = idw_be

end event

event ue_list_open;call super::ue_list_open;Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_proyecto_tbl'
sl_param.titulo  = 'Proyecto'

sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	dw_it_fc_del.Reset()
	//Limpiar dw Dinamicos
	idw_bed.DataObject = ""
	//Recuperar
	wf_retrieve_periodos(sl_param.field_ret[1])
	dw_pry.Retrieve(sl_param.field_ret[1])
	idw_be.Retrieve(sl_param.field_ret[1],is_tipfc_beneficio)
	wf_retrieve_fc(sl_param.field_ret[1],is_tipfc_inversion,idw_in)
	wf_retrieve_fc(sl_param.field_ret[1],is_tipfc_cfijo,idw_cf)
	wf_retrieve_fc(sl_param.field_ret[1],is_tipfc_cvar,idw_cv)
	wf_retrieve_fc(sl_param.field_ret[1],is_tipfc_lcred,idw_lc)
	wf_retrieve_matriz_fc(sl_param.field_ret[1])
	idw_im.Retrieve(sl_param.field_ret[1],is_tipfc_impuesto)
	//TriggerEvent ('ue_modify')
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String ls_nro_pry
Long ll_max_itm_fc
Long ll_itm_fc, ll_itm_frm, ll_itm_frm_aux, ll_max_itm_frm, ll_fila, ll_itm_fc_aux
Integer li_i, li_TotMeses, li_j, li_count
String ls_desc_periodo
Decimal ln_valor, ln_pct_impuesto
String ls_flag_frm, ls_formula, ls_flag_result, ls_descripcion

idw_be.AcceptText()
idw_bed.AcceptText()
dw_pry.AcceptText()
idw_in.AcceptText()
idw_cf.AcceptText()
idw_cv.AcceptText()
idw_lc.AcceptText()
idw_im.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
If IsNull(ls_nro_pry) or Len(Trim(ls_nro_pry))=0 then
	MessageBox("Aviso","Debe seleccionar algun proyecto para poder grabar")
	Return
end if

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

//IF	(tab_fc.tabpage_be.dw_be.ii_update = 1 or tab_fc.tabpage_be.dw_bed.ii_update = 1) AND lbo_ok = TRUE THEN
	//Proceder con item eliminados
	For li_i = 1 to dw_it_frm_del.RowCount()
		ll_itm_fc  = dw_it_frm_del.GetItemNumber(li_i,"nro_item_fc")
		ll_itm_frm = dw_it_frm_del.GetItemNumber(li_i,"nro_item_frm")
		
		If IsNull(ll_itm_frm) then//Borrar Todo la Definicion del Beneficio
			Delete from pry_fc_det_mes
			 where nro_proyecto = :ls_nro_pry
				and nro_item_fc = :ll_itm_fc;

			Delete from pry_fc_det_frm_mes
			where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
			
			Delete from pry_fc_det_frm
			where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
			
			Delete from pry_fc_det
			where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
		else//Borrar un item de la definicion del beneficio
			Delete from pry_fc_det_frm_mes
			where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc
			and nro_item_frm = :ll_itm_frm;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
			
			Delete from pry_fc_det_frm
			where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc
			and nro_item_frm = :ll_itm_frm;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
		end if			
	Next	
	//Establece el nro proyecto y el item fc a registros k le falte
	Select nvl(max(nro_item_fc),0) into :ll_max_itm_fc
	  from pry_fc_det
	 where nro_proyecto = :ls_nro_pry;
	If f_valida_transaccion(sqlca) = False then GoTo error_bd
	
	ll_itm_fc = ll_max_itm_fc
	for li_i = 1 to idw_be.RowCount()
		If IsNull(idw_be.Object.nro_item_fc[li_i]) then
			ll_itm_fc = ll_itm_fc + 1
			idw_be.Object.nro_proyecto[li_i] = ls_nro_pry
			idw_be.Object.rubro_fc[li_i] = is_tipfc_beneficio
			idw_be.Object.cod_usr[li_i] = gs_user
			idw_be.Object.nro_item_fc[li_i] = ll_itm_fc
		end if
	next

	IF idw_be.Update() = -1 then
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion de Beneficios","Se ha procedido al rollback",exclamation!)
	END IF
//END IF
//********************************
//******* GRABAR BENEFICIO actualmente seleccionado*******
//********************************
ll_itm_fc = idw_be.GetItemNumber(idw_be.GetRow(),"nro_item_fc")


li_TotMeses = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]


//
Select nvl(max(nro_item_frm),0) into :ll_max_itm_frm
  from pry_fc_det_frm
 where nro_proyecto = :ls_nro_pry
   and nro_item_fc = :ll_itm_fc;
If f_valida_transaccion(sqlca) = False then GoTo error_bd

ll_itm_frm = ll_max_itm_frm
For li_i = 1 to idw_bed.RowCount()
	ll_itm_frm_aux = idw_bed.GetItemNumber(li_i,"nro_item_frm")
	ll_fila 			= idw_bed.GetItemNumber(li_i,"fila")
	ls_descripcion = idw_bed.GetItemString(li_i,"descripcion")
	ls_flag_frm 	= idw_bed.GetItemString(li_i,"flag_formula")
	ls_formula 		= idw_bed.GetItemString(li_i,"formula")
	ls_flag_result = idw_bed.GetItemString(li_i,"flag_resultado")
	
	If IsNull(ll_itm_frm_aux) or ll_itm_frm_aux <=0 then//Nuevo
		ll_itm_frm = ll_itm_frm + 1
		idw_bed.SetItem(li_i,"nro_item_frm",ll_itm_frm)
		
		Insert into pry_fc_det_frm(nro_proyecto, nro_item_fc, nro_item_frm, descripcion, cod_usr,
		flag_formula, formula, flag_resultado, fila, flag_replicacion)
		values(:ls_nro_pry, :ll_itm_fc, :ll_itm_frm, :ls_descripcion, :gs_user,
				 :ls_flag_frm, :ls_formula, :ls_flag_result, :ll_fila, '1');
		If f_valida_transaccion(sqlca) = False then GoTo error_bd
		For li_j = 1 to li_totMeses
			ls_desc_periodo = "M"+Right("00"+String(li_j),3)
			ln_valor = idw_bed.GetItemNumber(li_i,ls_desc_periodo)
			Insert into pry_fc_det_frm_mes(nro_proyecto, nro_item_fc, nro_item_frm, mes, valor, flag_replicacion)
			values(:ls_nro_pry, :ll_itm_fc, :ll_itm_frm, :li_j, :ln_valor, '1');
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
		next		
	else//Ya Existe: Actualizar
		Update pry_fc_det_frm
			set descripcion = :ls_descripcion,
				 flag_formula = :ls_flag_frm,
				 formula = :ls_formula,
				 fila = :ll_fila,
				 flag_resultado = :ls_flag_result
		 where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc
			and nro_item_frm = :ll_itm_frm_aux;
	
		For li_j = 1 to li_totMeses
			ls_desc_periodo = "M"+Right("00"+String(li_j),3)
			ln_valor = idw_bed.GetItemNumber(li_i,ls_desc_periodo)
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
			
			Select count(*) into :li_count
			  from pry_fc_det_frm_mes
			 where nro_proyecto = :ls_nro_pry
			   and nro_item_fc = :ll_itm_fc
			   and nro_item_frm = :ll_itm_frm_aux
				and mes = :li_j;
			
			If li_count = 0 then
				Insert into pry_fc_det_frm_mes(nro_proyecto, nro_item_fc, nro_item_frm, mes, valor, flag_replicacion)
				values(:ls_nro_pry, :ll_itm_fc, :ll_itm_frm_aux, :li_j, :ln_valor, '1');
				If f_valida_transaccion(sqlca) = False then GoTo error_bd
			elseif li_count = 1 then
				Update pry_fc_det_frm_mes
					set valor = :ln_valor
				 where nro_proyecto = :ls_nro_pry
					and nro_item_fc = :ll_itm_fc
					and nro_item_frm = :ll_itm_frm_aux
					and mes = :li_j;
				If f_valida_transaccion(sqlca) = False then GoTo error_bd
			end if
		next
	end if
next
//-------------------------------------------------
//----- GRABAR EL RESULTADO EN EL FC POR MES-------
//-------------------------------------------------
String ls_find//, ls_desc_periodo
Long ll_find, ll_count
//Decimal ln_valor
//
//li_TotalMeses = Integer(sle_mes.Text)
//ls_nro_pry = dw_master.GetItemString(dw_master.GetRow(),"nro_proyecto")
//ll_itm_fc = dw_master.GetItemNumber(dw_master.GetRow(),"nro_item_fc")
If idw_bed.RowCount()>0 then
	ls_find 	  = "flag_resultado = '1'"
	ll_find 	  = idw_bed.Find(ls_find,1,idw_bed.RowCount())
	
	If ll_find > 0 then
		For li_i = 1 to li_TotMeses
			ls_desc_periodo = "M"+Right("00"+String(li_i),3)
			ln_valor = idw_bed.GetItemNumber(ll_find,ls_desc_periodo)
			Select count(*) into :ll_count
			  from pry_fc_det_mes
			 where nro_proyecto = :ls_nro_pry
				and nro_item_fc = :ll_itm_fc
				and mes = :li_i;
			If f_valida_transaccion(sqlca) = False then GoTo error_bd
	
			If ll_count = 0 then
				Insert into pry_fc_det_mes(nro_proyecto, nro_item_fc, mes, cod_usr, valor,
				observaciones, flag_replicacion)
				Values(:ls_nro_pry, :ll_itm_fc, :li_i, :gs_user, :ln_valor,
				'Valor Generado en Automatico','1');
				If f_valida_transaccion(sqlca) = False then GoTo error_bd
	
			elseif ll_count = 1 then
				Update pry_fc_det_mes
					set valor = :ln_valor
				 where nro_proyecto = :ls_nro_pry
					and nro_item_fc = :ll_itm_fc
					and mes = :li_i;
				If f_valida_transaccion(sqlca) = False then GoTo error_bd
	
			end if
			
		Next
	else
		MessageBox("Aviso","Error al determinar Fila Resultado")
		Return
	end if
end if
//--------------------------------------------
//------- Registros Eliminados <> Beneficio
//--------------------------------------------
//Proceder con item eliminados
For li_i = 1 to dw_it_fc_del.RowCount()
	ll_itm_fc  = dw_it_fc_del.GetItemNumber(li_i,"nro_item_fc")
	
	Delete from pry_fc_det_mes
	 where nro_proyecto = :ls_nro_pry
		and nro_item_fc  = :ll_itm_fc;
	If f_valida_transaccion(sqlca) = False then GoTo error_bd
		
	Delete from pry_fc_det
	 where nro_proyecto = :ls_nro_pry
	   and nro_item_fc  = :ll_itm_fc;
	If f_valida_transaccion(sqlca) = False then GoTo error_bd
Next	
//----------------------------------------
//------ Actualizar Inversiones -----------
//----------------------------------------
If wf_update_fc(ls_nro_pry, li_TotMeses, idw_in) = -1 then
	goto error_bd
end if
//----------------------------------------
//------ Actualizar Costo Fijo -----------
//----------------------------------------
If wf_update_fc(ls_nro_pry, li_TotMeses, idw_cf) = -1 then
	goto error_bd
end if
//--------------------------------------------
//------ Actualizar Costo Variable -----------
//--------------------------------------------
If wf_update_fc(ls_nro_pry, li_TotMeses, idw_cv) = -1 then
	goto error_bd
end if
//--------------------------------------------
//------ Actualizar Linea Credito -----------
//--------------------------------------------
If wf_update_fc(ls_nro_pry, li_TotMeses, idw_lc) = -1 then
	goto error_bd
end if
//--------------------------------------------
//-------- Actualizar Impuesto   -------------
//--------------------------------------------
//If wf_update_fc(ls_nro_pry, li_TotMeses, idw_im) = -1 then
	//goto error_bd
//end if

Select nvl(max(nro_item_fc),0) into :ll_max_itm_fc
  from pry_fc_det
 where nro_proyecto = :ls_nro_pry;

If f_valida_transaccion(sqlca) = False then GoTo error_bd

ll_itm_fc = ll_max_itm_fc
For li_i = 1 to idw_im.RowCount()
	ll_itm_fc_aux = idw_im.GetItemNumber(li_i,"nro_item_fc")
	ll_fila 			= idw_im.GetItemNumber(li_i,"fila")
	ls_descripcion = idw_im.GetItemString(li_i,"descripcion")
//	ls_rubro     = idw_im.GetItemString(li_i,"rubro_fc")
	ln_pct_impuesto = idw_im.GetItemNumber(li_i,"tasa_impuesto")
	
	If IsNull(ll_itm_fc_aux) or ll_itm_fc_aux <=0 then//Nuevo
		ll_itm_fc = ll_itm_fc+ 1
		idw_im.SetItem(li_i,"nro_item_fc",ll_itm_fc)
		
		Insert into pry_fc_det(nro_proyecto, nro_item_fc, fila, rubro_fc, descripcion, cod_usr,
		observaciones, flag_replicacion, tasa_impuesto)
		values(:ls_nro_pry, :ll_itm_fc, :ll_fila, :is_tipfc_impuesto, :ls_descripcion, :gs_user,
				 null,'1',:ln_pct_impuesto);
		If f_valida_transaccion(sqlca) = False then 
			MessageBox("","error1")
			GoTo error_bd
		end if
	else//Ya Existe: Actualizar
		Update pry_fc_det
			set descripcion = :ls_descripcion,
				 fila = :ll_fila,
				 tasa_impuesto = :ln_pct_impuesto
		 where nro_proyecto = :ls_nro_pry
			and nro_item_fc = :ll_itm_fc_aux;
			
		If f_valida_transaccion(sqlca) = False then 
			MessageBox("","error22")
			GoTo error_bd
		end if

	end if

next
//IF idw_im.Update() = -1 then
//	lbo_ok = FALSE
//	goto error_bd
//END IF
/////////////////////
lbo_ok = True
IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_fc.tabpage_be.dw_be.ii_update = 0
END IF
Return
error_bd:
RollBack using SQLCA;
MessageBox(title,"Se ha procedido al RollBack")
Return
end event

event ue_update_pre;call super::ue_update_pre;Integer li_i, k, li_TotMeses
String ls_descripcion, ls_formula, ls_desc_periodo
Decimal lde_tot, lde_valor
//Validaciones
li_TotMeses = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]
for li_i = 1 to idw_be.RowCount()
	ls_descripcion = idw_be.Object.descripcion[li_i]
	If IsNull(ls_descripcion) or Len(Trim(ls_descripcion))=0 then
		MessageBox("Aviso","Debe ingresar una descripcion para el beneficio")
		ib_update_check = False
		Return
	end if
next
for li_i = 1 to idw_bed.RowCount()
	if idw_bed.Object.flag_formula[li_i] = '1' then
		ls_formula = idw_bed.Object.formula[li_i]
		if IsNull(ls_formula) or Len(Trim(ls_formula))=0 then
			MessageBox("Aviso","La formula no puede ser vacia")
			ib_update_check = False
			Return
		end if
	else
		lde_tot = 0
		for k = 1 to li_TotMeses
			ls_desc_periodo = "M"+Right("00"+String(k),3)
			lde_valor = idw_bed.GetItemNumber(li_i,ls_desc_periodo)
			If IsNull(lde_valor) then lde_valor = 0
			lde_tot = lde_tot + lde_valor
		next
		If lde_tot = 0 then
			MessageBox("Aviso","La fila "+String(li_i)+" no puede tener valor vacio en todos los periodos")
			ib_update_check = False
			Return
		end if
	end if
next
	
ib_update_check = True
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (tab_fc.tabpage_be.dw_be.ii_update = 1 OR tab_fc.tabpage_be.dw_bed.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		RollBack;
		tab_fc.tabpage_be.dw_be.ii_update = 0
		tab_fc.tabpage_be.dw_bed.ii_update = 0
	END IF
END IF

end event

type dw_periodos from datawindow within w_pt314_pry_fc
boolean visible = false
integer x = 2848
integer y = 28
integer width = 434
integer height = 340
integer taborder = 30
string title = "none"
string dataobject = "d_lis_pry_periodo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetTransObject(sqlca)
end event

type dw_it_fc_del from datawindow within w_pt314_pry_fc
boolean visible = false
integer x = 2784
integer y = 4
integer width = 471
integer height = 288
integer taborder = 40
string title = "none"
string dataobject = "d_lis_pry_it_fc_del"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_it_frm_del from datawindow within w_pt314_pry_fc
boolean visible = false
integer x = 2510
integer width = 279
integer height = 288
integer taborder = 50
string title = "none"
string dataobject = "d_lis_pry_it_frm_del"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_result from datawindow within w_pt314_pry_fc
boolean visible = false
integer x = 2167
integer width = 549
integer height = 340
integer taborder = 40
string title = "none"
string dataobject = "d_lis_pry_fc_det_frm_mes"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab_fc from tab within w_pt314_pry_fc
integer x = 23
integer y = 392
integer width = 3653
integer height = 1524
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_be tabpage_be
tabpage_in tabpage_in
tabpage_cf tabpage_cf
tabpage_cv tabpage_cv
tabpage_lc tabpage_lc
tabpage_im tabpage_im
tabpage_mfc tabpage_mfc
end type

on tab_fc.create
this.tabpage_be=create tabpage_be
this.tabpage_in=create tabpage_in
this.tabpage_cf=create tabpage_cf
this.tabpage_cv=create tabpage_cv
this.tabpage_lc=create tabpage_lc
this.tabpage_im=create tabpage_im
this.tabpage_mfc=create tabpage_mfc
this.Control[]={this.tabpage_be,&
this.tabpage_in,&
this.tabpage_cf,&
this.tabpage_cv,&
this.tabpage_lc,&
this.tabpage_im,&
this.tabpage_mfc}
end on

on tab_fc.destroy
destroy(this.tabpage_be)
destroy(this.tabpage_in)
destroy(this.tabpage_cf)
destroy(this.tabpage_cv)
destroy(this.tabpage_lc)
destroy(this.tabpage_im)
destroy(this.tabpage_mfc)
end on

type tabpage_be from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Beneficios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom048!"
long picturemaskcolor = 536870912
string powertiptext = "Definición de beneficios del proyecto"
st_1 st_1
dw_be dw_be
dw_bed dw_bed
end type

on tabpage_be.create
this.st_1=create st_1
this.dw_be=create dw_be
this.dw_bed=create dw_bed
this.Control[]={this.st_1,&
this.dw_be,&
this.dw_bed}
end on

on tabpage_be.destroy
destroy(this.st_1)
destroy(this.dw_be)
destroy(this.dw_bed)
end on

type st_1 from statictext within tabpage_be
integer x = 14
integer y = 444
integer width = 832
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Definición del Beneficio"
boolean focusrectangle = false
end type

type dw_be from u_dw_abc within tabpage_be
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 24
integer width = 1989
integer height = 396
integer taborder = 30
string dataobject = "d_abc_pry_beneficio"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
dw_it_frm_del.Reset()

end event

event ue_output;call super::ue_output;String ls_nro_pry
Long ll_itm_fc

ls_nro_pry = GetItemString(al_row,"nro_proyecto")
ll_itm_fc  = GetItemNumber(al_row,"nro_item_fc")
if IsNull(ll_itm_fc) then
	idw_bed.Reset()
else
	wf_retrieve_beneficio_def(ls_nro_pry, ll_itm_fc)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='md'
is_dwform = 'tabular'

idw_det = tab_fc.tabpage_be.dw_bed

ib_delete_cascada = true

ii_ck[1]=1
ii_rk[1]=1
ii_dk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_insert;//Override
long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	idw_bed.Reset()
//	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF
Return 0

end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_itm_fc, ll_row_del
ll_itm_fc = GetItemNumber(GetRow(),"nro_item_fc")

//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_fc) or ll_itm_fc <= 0) then
	ll_row_del = dw_it_frm_del.InsertRow(0)
	dw_it_frm_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
end if
end event

type dw_bed from u_dw_abc within tabpage_be
event ue_det_insertar ( )
event ue_det_agregar ( )
event ue_det_eliminar ( )
integer x = 14
integer y = 504
integer width = 3579
integer height = 880
integer taborder = 40
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_det_insertar();Integer li_i, li_mes
String ls_col
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
		SetItem(li_i,"flag_resultado","0")
	next
	SetItem(li_i - 1,"flag_resultado","1")
	
	for li_i = ll_row + 1 to Rowcount()
		If GetItemString(li_i,"flag_formula")='1' then
			SetItem(li_i,"formula",wf_act_formula(GetItemString(li_i,"formula"),ll_row,'I'))	
		end if
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	SetItem(ll_row,"flag_resultado","1")
end if
//Proteger formula y valores por mes
idw_bed.Modify("formula.protect='0~tif( integer(flag_formula) =1,0,1)' ")
li_mes = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]
For li_i = 1 to li_mes
	ls_col = "M"+Right("0"+String(li_i),2)
	idw_bed.Modify(ls_col+".protect='0~tif( integer(flag_formula) =1,1,0)' ")
Next
end event

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'

idw_mst = idw_be
//idw_det = idw_bed

ii_ck[1]=1
ii_rk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_insert;//Override
//IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
//	IF idw_mst.il_row = 0 THEN
//		MessageBox("Error", "No ha seleccionado registro Maestro")
//		RETURN - 1
//	END IF
//END IF

long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	for li_i = 1 to RowCount()
		SetItem(li_i,"flag_resultado","0")
	next
	SetItem(li_i -1 ,"flag_resultado","1")
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF
//Proteger formula y valores por mes
idw_bed.Modify("formula.protect='0~tif( integer(flag_formula) =1,0,1)' ")
li_mes = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]
For li_i = 1 to li_mes
	ls_col = "M"+Right("00"+String(li_i),3)
	idw_bed.Modify(ls_col+".protect='0~tif( integer(flag_formula) =1,1,0)' ")
Next

RETURN ll_row

end event

event ue_delete;//Override
Integer li_i
Long ll_row, ll_row_del, ll_itm_frm, ll_itm_fc
String ls_fila, ls_formula
ll_row = GetRow()
//Antes de Eliminar
//Obtener el Nro Item Frm
ll_itm_fc = idw_be.GetItemNumber(idw_be.GetRow(),"nro_item_fc")
ll_itm_frm = GetItemNumber(ll_row,"nro_item_frm")
//Verificar que la fila que se quiere eliminar no sea usada en alguna formula.
ls_fila = '[F'+Right('0'+String(ll_row),2)+']'
For li_i = ll_row +1 to RowCount()
	If GetItemString(li_i,"flag_formula")='1' then
		ls_formula = GetItemString(li_i,"formula")
		If Pos(ls_formula,ls_fila,1)>0 then
			MessageBox("Aviso","No se puede eliminar esta fila pues esta siendo utilizada en alguna formula")
			return 0
		end if	
	end if
next
//Eliminar
DeleteRow(0)
//Despues de Eliminar
For li_i = ll_row to Rowcount()
	If GetItemString(li_i,"flag_formula")='1' then
		SetItem(li_i,"formula",wf_act_formula(GetItemString(li_i,"formula"),ll_row,'D'))
	end if
next
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
	SetItem(li_i,"flag_resultado","0")
next
SetItem(li_i - 1,"flag_resultado","1")
//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_frm) or ll_itm_frm <= 0) then
	ll_row_del = dw_it_frm_del.InsertRow(0)
	dw_it_frm_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
	dw_it_frm_del.SetItem(ll_row_del,"nro_item_frm",ll_itm_frm)
end if
Return 0
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_cadena, ls_fila, ls_result = "La(s) Fila(s): "
Integer li_start, li_pos, k=0, li_i, li_TotMeses, li_rsp
String data_old, ls_desc_periodo, ls_msj, ls_formula
Decimal ln_valor, ln_tot

ls_cadena = data

idw_bed.AcceptText()
li_TotMeses = dw_pry.Object.nro_meses_eval[dw_pry.GetRow()]

Choose case GetColumnName()
	Case "formula"
		data_old = GetItemString(row,"formula",Primary!,True)
		//Valida que se utilice filas que ya existen
		li_start = 1
		Do while Pos(ls_cadena,'[F',li_start)>0
			li_pos = Pos(ls_cadena,'[F',li_start)
			ls_fila = Mid(ls_cadena,li_pos+2,2)
			If Integer(ls_fila)>=row then
				k = k + 1
				if k = 1 then
					ls_result = ls_result+String(Integer(ls_fila))
				else
					ls_result = ls_result+", "+String(Integer(ls_fila))
				end if
			end if
			li_start = li_pos + 5
		Loop
		If k > 0 then
			MessageBox("Aviso",ls_result+" No pueden ser utilizadas en la formula")
			Object.formula[row]=data_old
			Return 2
		end if
		wf_evalua_formula()
	Case "flag_formula"
		data_old = GetItemString(row,"flag_formula",Primary!,False)
		If data_old = "1" then
			ls_msj = "Esta intentando quitar una formula:"&
							+"~n1. Se eliminaran los calculos hechos en este registro"&
							+"~n2. Se actualizaran las registros cuya fórmula utilizen esta fila"&
							+"~n¿Desea Continuar?"
			li_rsp = MessageBox("Aviso",ls_msj,Question!,YesNo!,2)
			If li_rsp = 1 then
				idw_bed.Object.formula[row] = ""
				for li_i = 1 to li_TotMeses
					ls_desc_periodo = "M"+Right("0"+String(li_i),2)
					ln_valor = GetItemNumber(row,ls_desc_periodo)
					If Not IsNull(ln_valor) then
						idw_bed.SetItem(row,ls_desc_periodo,0)
					end if
				next
				wf_evalua_formula()
			else
				return 2
			end if
		else
			ln_tot = 0
			for li_i = 1 to li_TotMeses
				ls_desc_periodo = "M"+Right("00"+String(li_i),3)
				ln_valor = GetItemNumber(row,ls_desc_periodo)
				If IsNull(ln_valor) then ln_valor = 0
				ln_tot = ln_tot + ln_valor
			next
			if ln_tot > 0 then
				ls_msj = "Esta intentando establecer una formula:"&
								+"~n1. Se eliminaran los valores de los periodos en este registro"&
								+"~n2. Se actualizaran las registros cuya fórmula utilizen esta fila"&
								+"~n¿Desea Continuar?"
				
				li_rsp = MessageBox("Aviso",ls_msj,Question!,YesNo!,2)
				If li_rsp = 1 then
					for li_i = 1 to li_TotMeses
						ls_desc_periodo = "M"+Right("00"+String(li_i),3)
						ln_valor = GetItemNumber(row,ls_desc_periodo)
						If Not IsNull(ln_valor) then
							idw_bed.SetItem(row,ls_desc_periodo,0)
						end if
					next
					wf_evalua_formula()
				else
					return 2
				end if	
			
			end if
		end if
	Case "flag_resultado"
	Case "descripcion"
	Case else
		wf_evalua_formula()
end choose
end event

type tabpage_in from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Inversiones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Form!"
long picturemaskcolor = 536870912
string powertiptext = "Inversiones del proyecto"
dw_in dw_in
end type

on tabpage_in.create
this.dw_in=create dw_in
this.Control[]={this.dw_in}
end on

on tabpage_in.destroy
destroy(this.dw_in)
end on

type dw_in from u_dw_abc within tabpage_in
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 24
integer width = 3589
integer height = 1364
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_inversion)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	SetItem(ll_row,"rubro_fc",is_tipfc_inversion)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;//Override
long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_inversion)
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type tabpage_cf from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Costos Fijos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom054!"
long picturemaskcolor = 536870912
string powertiptext = "Costos fijos del proyecto"
dw_cf dw_cf
end type

on tabpage_cf.create
this.dw_cf=create dw_cf
this.Control[]={this.dw_cf}
end on

on tabpage_cf.destroy
destroy(this.dw_cf)
end on

type dw_cf from u_dw_abc within tabpage_cf
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 18
integer y = 24
integer width = 3579
integer height = 1356
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_cfijo)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	SetItem(ll_row,"rubro_fc",is_tipfc_cfijo)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_insert;//Override
long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_cfijo)
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event ue_delete;//Override
Integer li_i
Long ll_row, ll_itm_fc, ll_row_del
ib_insert_mode = False

ll_itm_fc = GetItemNumber(GetRow(),"nro_item_fc")
//Eliminar
ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF
//Despues de Eliminar
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_fc) or ll_itm_fc <= 0) then
	ll_row_del = dw_it_fc_del.InsertRow(0)
	dw_it_fc_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
end if
Return ll_row
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_cv from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Costos Variables"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom084!"
long picturemaskcolor = 536870912
string powertiptext = "Costos variables del proyecto"
dw_cv dw_cv
end type

on tabpage_cv.create
this.dw_cv=create dw_cv
this.Control[]={this.dw_cv}
end on

on tabpage_cv.destroy
destroy(this.dw_cv)
end on

type dw_cv from u_dw_abc within tabpage_cv
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 18
integer y = 24
integer width = 3575
integer height = 1356
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_delete;//Override
Integer li_i
Long ll_row, ll_itm_fc, ll_row_del
ib_insert_mode = False

ll_itm_fc = GetItemNumber(GetRow(),"nro_item_fc")
//Eliminar
ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF
//Despues de Eliminar
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_fc) or ll_itm_fc <= 0) then
	ll_row_del = dw_it_fc_del.InsertRow(0)
	dw_it_fc_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
end if
Return ll_row
end event

event ue_insert;//Override
long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

type tabpage_lc from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Linea Crédito"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "FormatDollar!"
long picturemaskcolor = 536870912
string powertiptext = "Impuestos del proyecto"
dw_lc dw_lc
end type

on tabpage_lc.create
this.dw_lc=create dw_lc
this.Control[]={this.dw_lc}
end on

on tabpage_lc.destroy
destroy(this.dw_lc)
end on

type dw_lc from u_dw_abc within tabpage_lc
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 18
integer y = 28
integer width = 3579
integer height = 1352
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	//SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	//SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_delete;//Override
Integer li_i
Long ll_row, ll_itm_fc, ll_row_del
ib_insert_mode = False

ll_itm_fc = GetItemNumber(GetRow(),"nro_item_fc")
//Eliminar
ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF
//Despues de Eliminar
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_fc) or ll_itm_fc <= 0) then
	ll_row_del = dw_it_fc_del.InsertRow(0)
	dw_it_fc_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
end if
Return ll_row
end event

event ue_insert;//Override
long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	//SetItem(ll_row,"rubro_fc",is_tipfc_cvar)
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type tabpage_im from userobject within tab_fc
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Impuestos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom096!"
long picturemaskcolor = 536870912
dw_im dw_im
end type

on tabpage_im.create
this.dw_im=create dw_im
this.Control[]={this.dw_im}
end on

on tabpage_im.destroy
destroy(this.dw_im)
end on

type dw_im from u_dw_abc within tabpage_im
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 18
integer y = 28
integer width = 2062
integer height = 1348
integer taborder = 20
string dataobject = "d_abc_pry_impuesto"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count

ll_count = RowCount()

If ll_count > 0 then
	Long ll_row
	ll_row = getrow()
	InsertRow(ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_impuesto)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	SetItem(ll_row,"rubro_fc",is_tipfc_impuesto)
end if
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete;//Override
Integer li_i
Long ll_row, ll_itm_fc, ll_row_del
ib_insert_mode = False

ll_itm_fc = GetItemNumber(GetRow(),"nro_item_fc")
//Eliminar
ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF
//Despues de Eliminar
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
//Guardo en la lista de items eliminados para que se proceda cuando se realice el guardado:
If Not(IsNull(ll_itm_fc) or ll_itm_fc <= 0) then
	ll_row_del = dw_it_fc_del.InsertRow(0)
	dw_it_fc_del.SetItem(ll_row_del,"nro_item_fc",ll_itm_fc)
end if
Return ll_row
end event

event ue_insert;//Override
long ll_row
Integer li_i, li_mes
String ls_col

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	SetItem(ll_row,"fila",ll_row)
	SetItem(ll_row,"rubro_fc",is_tipfc_impuesto)
	//THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	//IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type tabpage_mfc from userobject within tab_fc
integer x = 18
integer y = 112
integer width = 3616
integer height = 1396
long backcolor = 79741120
string text = "Resultados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom079!"
long picturemaskcolor = 536870912
dw_mfc dw_mfc
end type

on tabpage_mfc.create
this.dw_mfc=create dw_mfc
this.Control[]={this.dw_mfc}
end on

on tabpage_mfc.destroy
destroy(this.dw_mfc)
end on

type dw_mfc from u_dw_abc within tabpage_mfc
integer x = 14
integer y = 28
integer width = 3584
integer height = 1356
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
//idw_mst = idw_master

ii_ck[1]=1
ii_rk[1]=1
end event

type dw_pry from u_dw_abc within w_pt314_pry_fc
integer x = 37
integer y = 16
integer width = 2181
integer height = 364
string dataobject = "d_abc_proyecto"
end type

event constructor;call super::constructor;SetTransObject(sqlca)
//is_mastdet = 'md'
InsertRow(0)
ii_ck[1] = 1
end event

