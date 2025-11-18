$PBExportHeader$n_cst_impresion.sru
forward
global type n_cst_impresion from nonvisualobject
end type
end forward

global type n_cst_impresion from nonvisualobject
end type
global n_cst_impresion n_cst_impresion

type variables
/***
*
*   Definiciones de caracteres de impresion para Impresora EPSON
*
*/

string 	is_PR_10CPI   	= char(27) + char(80), &
			is_PR_12CPI   	= char(27) + char(77), &
			is_PR_EMP_ON  	= char(27) + char(69), &
			is_PR_EMP_OFF 	= char(27) + char(70), &
			is_PR_ITA_ON 	= char(27) + char(52), &
			is_PR_ITA_OFF  = char(27) + char(53), &
			is_PR_CON_ON 	= char(27) + char(15), &
			is_PR_CON_OFF  = char(27) + char(18), &
			is_PR_NEG_ON 	= char(27) + char(71), &
			is_PR_NEG_OFF  = char(27) + char(72), &
			is_PR_NLQ_ON 	= char(27) + char(71), &
			is_PR_NLQ_OFF  = char(27) + char(72), &
			is_PR_ALT_ON 	= char(27) + "w" + char(1), &
			is_PR_ALT_OFF  = char(27) + "w" + char(0), &
			is_PR_WID_ON 	= char(27) + "W" + char(1), &
			is_PR_WID_OFF  = char(27) + "W" + char(0)

/**********************************************************************************
*
*       DEFINICIONES PARA EL TIPO DE IMPRESION
*       Autor: Jhonny Ramirez Chiroque
*
*********************************************************************************/
string 	is_SetItalic 			= CHAR(27)+'4', &
			is_CancelItalic 		= CHAR(27)+'5', &
			is_SetUnderline 		= CHAR(27)+'-1', &
			is_CancelUnderline 	= CHAR(27)+'-0', &
			is_SetNegrita 			= CHAR(27)+'E', &
			is_CancelNegrita 		= CHAR(27)+'F', &
			is_SetCondensado 		= CHAR(15), &
			is_CancelCondensado 	= CHAR(18), &
			is_SetMode10CPI 		= CHAR(27)+'P', &
			is_SetMode12CPI 		= CHAR(27)+'M', &
			is_InitialitePrinter = CHAR(27)+'@', &
			is_SetPage22Lines 	= CHAR(27)+"C"+CHAR(22), &
			is_SetPage33Lines 	= CHAR(27)+"C"+CHAR(33), &
			is_SetPage66Lines 	= CHAR(27)+"C"+CHAR(66), &
			is_SetPage60Lines 	= CHAR(27)+"C"+CHAR(60), &
			is_SetDoubleWidthOneLine 	= CHAR(14), &
			is_CancelDoubleWidthOneLine= CHAR(20), &
			is_SetDoubleWidthMode 		= CHAR(27)+"W1", &
			is_CancelDoubleWidthMode 	= CHAR(27)+"W0", &
			is_SetDoubleHeightMode 		= CHAR(27)+"w1", &
			is_CancelDoubleHeightMode 	= CHAR(27)+"w0", &
			is_SetSuperscriptMode 		= CHAR(27)+"S0", &
			is_SetSubscriptMode 				= CHAR(27)+"S1", &
			is_CancelSuperAndSubScriptMode= CHAR(27)+"T", &
			is_SetLeftJustification 		= CHAR(27)+"a"+CHAR(0), &
			is_SetRightJustification 		= CHAR(27)+"a"+CHAR(1), &
			is_SetCenterJustification 		= CHAR(27)+"a"+CHAR(2), &
			is_SetFullJustification 		= CHAR(27)+"a"+CHAR(3), &
			is_FormFeed 						= CHAR(12), &
			is_LineFeed 						= CHAR(10), &
			is_SetLeftMargin4 				= CHAR(27)+"l"+CHAR(4), &
			is_SetLeftMargin3 				= CHAR(27)+"l"+CHAR(3), &
			is_SetLeftMargin2 				= CHAR(27)+"l"+CHAR(2), &
			is_SetLeftMargin1 				= CHAR(27)+"l"+CHAR(1), &
			is_SetRightMargin100 			= CHAR(27)+"Q"+CHAR(100), &
			is_SetRightMargin180 			= CHAR(27)+"Q"+CHAR(180), &
			is_SetDraftMode 					= CHAR(27)+"x"+CHAR(0), &
			is_Set1_8LineSpacing 			= CHAR(27)+"0", &
			is_Set7_72LineSpacing 			= CHAR(27)+"1", &
			is_Set1_6LineSpacing 			= CHAR(27)+"2", &
			is_LineaSimpleHorizontal 		= CHAR(196), &
			is_LineaDobleHorizontal 		= CHAR(205), &
			is_Grande 							= '¥', &
			is_Chica 							= '¤', &
			is_Inicializa 						= CHAR(27)+'@'

			
end variables

forward prototypes
public function string of_setpagelines (integer ai_lines)
public function integer of_imprimir_ts (string as_dir)
public function boolean of_cri_lima (string as_dw, string as_nro_cri, string as_flag_ts)
public function boolean of_voucher (string as_dw, string as_origen, long al_nro, string as_empresa, string as_flag_ts, string as_print)
public function boolean of_voucher_cheque (string as_dw, string as_origen, long al_nro, string as_empresa, string as_flag_ts, string as_print, string as_tipo_imp)
public function integer of_imprimir_local (string as_dir, string as_archivo)
end prototypes

public function string of_setpagelines (integer ai_lines);return CHAR(27)+"C"+CHAR(ai_lines)
end function

public function integer of_imprimir_ts (string as_dir);string ls_run
ls_run = as_dir + "PRINTTS.BAT"
if run(ls_run, Minimized!) = -1 then
	MessageBox('Error', 'Hubo un error tratando de ejecutar el comando ' + ls_run)
	return 0
end if

return 1
end function

public function boolean of_cri_lima (string as_dw, string as_nro_cri, string as_flag_ts);//Variables cabecera del voucher
Date				ld_fecha_emision
string			ls_string
Long				ll_long, ll_i,ll_count_reg
Decimal			ldc_decimal

string			ls_dir_ts, ls_file, ls_cadena, ls_mensaje
integer 			li_FileNum,li_pos
u_ds_base	 	lds_data

lds_data	 = create u_ds_base

lds_data.dataobject = as_dw
lds_data.SetTransObject( SQLCA )
lds_data.Retrieve(as_nro_cri)

if lds_data.RowCount()= 0 then
	MessageBox('Aviso', 'No hay registro recuperados')
	destroy lds_data
	return false
end if

If SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	destroy lds_data
	return false
end if

if as_flag_ts = '1' then
	ls_dir_ts = '\\tsclient\c\'
else
	ls_dir_ts = 'c:\pb_exe\impresora\'
end if

If Not DirectoryExists ( ls_dir_ts ) Then
	MessageBox ("File Mgr", "Directory " + ls_dir_ts + " no existe" )
	destroy lds_data
	return false
End If

ls_file = ls_dir_ts + 'PRUEBA.PRN'

// Activo el nivel de paginas (Cheque Voucher)
// Activo a 12 CPI
// Tamaño Asc('69')
ls_cadena = is_InitialitePrinter + this.of_setpagelines(45) + is_SetMode12CPI + is_LineFeed &
			 + is_SetCondensado +  is_set1_6linespacing
			 
li_FileNum = FileOpen(ls_file, LineMode!, Write!, LockWrite!, Append!)

if li_FileNum = -1 then
	MessageBox('Aviso', 'Error al momento de aperturar el archivo')
	destroy lds_data
	return false
end if



//************ Armo la cebecera del Voucher *************

FileWrite(li_FileNum, ls_cadena )  

for ll_i = 1 to 4
	FileWrite( li_FileNum, is_set1_6linespacing + '' )
next

FileWrite(li_FileNum, is_set1_6linespacing +'' )



//sexta linea
ls_cadena = fill(' ', 18)+lds_data.object.retencion_igv_crt_proveedor [1]+fill(' ',3)+lds_data.object.proveedor_nom_proveedor [1]


//caracter de Ñ
IF len(ls_cadena) > 0 THEN //REMPLAZAR LA Ñ
	li_pos = Pos(ls_cadena,'Ñ',1)
	
	do while li_pos > 0
		ls_cadena = Replace(ls_cadena,li_pos,1,'¥')
		li_pos = Pos(ls_cadena,'Ñ',li_pos + 1)		 
	loop
END IF




FileWrite(li_FileNum, is_set1_6linespacing + ls_cadena )  

//setima linea
ls_cadena = fill(' ', 26)+lds_data.object.proveedor_ruc [1]
FileWrite(li_FileNum, is_set1_6linespacing + ls_cadena )  

//octava linea
ls_cadena = fill(' ', 27)+Trim(String(lds_data.object.retencion_igv_crt_fecha_emision [1],'dd/mm/yyyy'))
ls_cadena = ls_cadena + fill(" ", 35) +  "T.C :" 
ls_cadena = ls_cadena + String(lds_data.object.caja_bancos_tasa_cambio [1], "###,##0.000")
FileWrite(li_FileNum, is_set1_6linespacing + ls_cadena )  

for ll_i = 1 to 2
	FileWrite(li_FileNum, '' +  is_set1_6linespacing    )
next

FileWrite(li_FileNum, '')


//detalle
For ll_i = 1 to lds_data.Rowcount( )
	 //codigo sunat
	 ls_string = lds_data.object.doc_tipo_cod_sunat [ll_i]
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 2)
	 ls_string = ls_string + fill(' ',15)
	 ls_cadena = fill(' ', 9) + ls_string
	 
	 //serie
	 ls_string = Mid(lds_data.object.caja_bancos_det_nro_doc [ll_i],1,3)
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 3)
	 ls_string = ls_string + fill(' ',15)
	 ls_cadena = ls_cadena + ls_string
	 
	 //nro correlativo
	 ls_string = mid(lds_data.object.caja_bancos_det_nro_doc  [ll_i], 5,6 )
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 6)
	 ls_string = ls_string + fill(' ',25)
	 ls_cadena = ls_cadena + ls_string
	 
	 //fecha emision
	 ls_string = String(lds_data.object.cntas_pagar_fecha_emision	 [ll_i],'dd/mm/yyyy')
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
	 ls_string = ls_string + fill(' ',20)
	 ls_cadena = ls_cadena + ls_string
	 
	 //moneda
	 ls_string = lds_data.object.cntas_pagar_cod_moneda [ll_i]
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 3)
	 ls_string = ls_string + fill(' ',3)
	 ls_cadena = ls_cadena + ls_string
	 
	 //importe del pago
	 ls_string = f_llena_caracteres(' ',String(lds_data.object.importe_det [ll_i],'###,##0.00'),10)
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
	 ls_string = ls_string + fill(' ',30 - len(ls_string))
	 ls_cadena = ls_cadena + ls_string
	 
	 //moneda
	 ls_string = lds_data.object.soles [ll_i]
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 3)
	 ls_string = ls_string + fill(' ',3)
	 ls_cadena = ls_cadena + ls_string
	 
	 //importe retenido
	 ls_string = f_llena_caracteres(' ',String(lds_data.object.caja_bancos_det_impt_ret_igv [ll_i],'###,##0.00'),10)
	 if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
	 ls_string = ls_string + fill(' ',20)
	 ls_cadena = ls_cadena + ls_string
	 

	
	 
	 //detalle		 
	 FileWrite(li_FileNum, is_set7_72linespacing + ls_cadena )
	 
	 
	 
Next


ll_count_reg = 0
ll_count_reg = lds_data.rowcount()

//espacios en el detalle
for ll_i = 1 to 44 - ll_count_reg
	FileWrite(li_FileNum, is_set1_6linespacing + '' )
next

//totales
ls_string = f_llena_caracteres(' ',String(lds_data.object.total_x_doc [1],'###,##0.00'),10)
if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
ls_string = fill(' ',112) + ls_string + fill(' ',36 - len(ls_string)) 
ls_cadena = ls_string


ls_string = f_llena_caracteres(' ',String(lds_data.object.total_retenciones [1],'###,##0.00'),10)
if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
ls_string = ls_string 
ls_cadena = ls_cadena + ls_string

FileWrite(li_FileNum, ls_cadena )



ls_string = lds_data.object.total_en_letras [1]

if isnull(ls_string) or Trim(ls_string) = '' then ls_string = fill(' ', 10)
ls_string = fill(' ',10) + ls_string
ls_cadena = ls_string

FileWrite(li_FileNum, ls_cadena )



// Culmino el documento
FileWrite(li_FileNum, is_FormFeed)

//Cierro el archivo
FileClose(li_FileNum)



if as_flag_ts = '0' then
	this.of_imprimir_local(ls_dir_ts, ls_file )
else	
	this.of_imprimir_ts(ls_dir_ts)
end if

destroy lds_data
return true

end function

public function boolean of_voucher (string as_dw, string as_origen, long al_nro, string as_empresa, string as_flag_ts, string as_print);//Variables cabecera del voucher
Date				ld_fecha_emision
string			ls_string, ls_run, ls_dir_ts, ls_file, ls_cadena, ls_mensaje
Long				ll_long, ll_i
Decimal			ldc_decimal
integer 			li_FileNum,li_linea_max,li_count_det,li_count_blc
u_ds_base	 	lds_data

lds_data	 = create u_ds_base

lds_data.dataobject = as_dw
lds_data.SetTransObject( SQLCA )
lds_data.Retrieve(as_origen, al_nro, as_empresa)


IF as_print = 'EPSON LX-300' THEN
	li_count_det = 12	
	li_count_blc = 13
ELSE
	li_count_det = 13	
	li_count_blc = 14	
END IF



if lds_data.RowCount()= 0 then
	MessageBox('Aviso', 'No hay registro recuperados')
	destroy lds_data
	return false
end if

If SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	destroy lds_data
	return false
end if
if as_flag_ts = '1' then
	ls_dir_ts = '\\tsclient\c\'
else
	ls_dir_ts = 'c:\pb_exe\impresora\'
end if

If Not DirectoryExists ( ls_dir_ts ) Then
	MessageBox ("File Mgr", "Directory " + ls_dir_ts + " no exista" )
	destroy lds_data
	return false
End If

ls_file = ls_dir_ts + 'PRUEBA.PRN'

if FileExists(ls_file) then
	ls_cadena = ''
else
	// Activo el nivel de paginas (Cheque Voucher)
	// Activo a 12 CPI
	// Tamaño Asc('0')
	ls_cadena = is_CancelCondensado + this.of_setpagelines( 32) &
				 + is_SetMode12CPI 
end if

li_FileNum = FileOpen(ls_file, LineMode!, Write!, LockWrite!, Replace!)

if li_FileNum = -1 then
	MessageBox('Aviso', 'Error al momento de aperturar el archivo')
	destroy lds_data
	return false
end if

//FileWrite(li_FileNum, ls_cadena)  

//************ Armo la cebecera del Voucher *************

// Primera Linea = Empresa + Fecha Emision
ls_cadena = ls_cadena + fill(" ", 9) + left(as_empresa,50) + Fill(" ", 58 - len(as_empresa))
ld_fecha_emision = Date(lds_data.object.fecha_emision[1])
if Not IsNUll(ld_fecha_emision ) then 
	ls_cadena += string(ld_fecha_emision, 'dd/mm/yyyy')
end if
FileWrite(li_FileNum, ls_cadena + is_LineFeed )  

// Segunda Linea = Nombre Banco + Cod_ctabco + nro_cheque
ls_string = left(lds_data.object.nom_banco [1], 23)
if IsNull(ls_string) then ls_string = fill(" ", 23)
ls_cadena = fill(" ", 6) + ls_string + fill(" ", 30 - len(ls_string))

ls_string = lds_data.object.cod_ctabco[1]
if IsNull(ls_string) then ls_string = fill(" ", 20)
ls_cadena = ls_cadena + ls_string + fill(" ", 33 - len(ls_string))

ls_string = string(lds_data.object.nro_cheque[1])
if IsNull(ls_string) then ls_string = fill(" ", 10)
ls_cadena = ls_cadena + ls_string
FileWrite(li_FileNum, ls_cadena + is_LineFeed )  

// Tercera Linea = AFavor + Voucher
ls_string = left(lds_data.object.afavor [1],49)
if IsNull(ls_string) then ls_string = fill(" ", 49)
ls_cadena = fill(" ", 11) + ls_string + fill(" ", 57 - len(ls_string))

ls_string = lds_data.object.origen[1] + string(lds_data.object.ano[1]) &
			 + string(lds_data.object.mes[1]) + string(lds_data.object.nro_libro[1]) &
			 + string(lds_data.object.nro_asiento[1])
ls_cadena += ls_string
FileWrite(li_FileNum, ls_cadena )  


// Tercera Linea = Tasa Cambio + Total
ls_cadena = fill(" ",50) + is_SetNegrita + "T.CAMBIO    TOTAL" + is_CancelNegrita
FileWrite(li_FileNum, ls_cadena )  

// Tercera Linea = Caja Obs + Tipo Cambio + Total
ls_string = left(lds_data.object.caja_bancos_obs [1], 42)
if IsNull(ls_string) then ls_string = fill(" ", 42)
ls_cadena = fill(" ", 8) + ls_string + fill(" ", 45 - len(ls_string))

ls_string = string(lds_data.object.tasa_cambio[1], "###,##0.000") &
			 + fill(" ", 4) + lds_data.object.cod_moneda[1] &
			 + string(lds_data.object.imp_total[1], "###,##0.00")
			 
if IsNull(ls_string) then ls_string = fill(" ", 14)
ls_cadena += ls_string

FileWrite(li_FileNum, ls_cadena + is_LineFeed)  

// ******************************************************

// Activo el condensado
FileWrite(li_FileNum, is_SetCondensado )  

//Imprimo cada una de las lineas
li_linea_max = lds_data.RowCount()

// Ingreso varias lineas en Blanco
IF li_linea_max > li_count_det THEN
	li_linea_max = li_count_det
END IF


//Imprimo cada una de las lineas
for ll_i = 1 to li_linea_max
	ls_cadena = ''
	ls_string = left(lds_data.object.cencos[ll_i],7)
	if ISNull(ls_string) then ls_string = fill(' ', 7)
	ls_cadena = ls_string + fill(' ', 11 - len(ls_string))

	ls_string = lds_data.object.cnta_ctbl [ll_i]
	if ISNull(ls_string) then ls_string = fill(" ", 10)
	ls_cadena = ls_cadena + ls_string + fill(' ', 13 - len(ls_string))
	
	ls_string = lds_data.object.cod_relacion[ll_i]
	if ISNull(ls_string) then ls_string = fill(" ", 8)
	ls_cadena = ls_cadena + ls_string + fill(' ', 12 - len(ls_string))
	
	ls_string = left(lds_data.object.tipo_docref1[ll_i],4)
	if ISNull(ls_string) then ls_string = fill(" ", 4)
	ls_cadena = ls_cadena + ls_string + fill(' ', 8 - len(ls_string))

	ls_string = left(lds_data.object.nro_docref1[ll_i],15)
	if ISNull(ls_string) then ls_string = fill(" ", 15)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.soles_cargo[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.soles_abono[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.dolares_cargo[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))
	
	ls_string = f_llena_caracteres(' ', string(lds_data.object.dolares_abono[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

	FileWrite(li_FileNum, ls_cadena )
	
next



for ll_i = 1 to li_count_blc - li_linea_max
	FileWrite(li_FileNum, '' )
next

// Coloco la Linea de Resultados Totales
ls_cadena = Fill(" ", 64)

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_soles_cargo[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_soles_abono[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_dolares_cargo[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_dolares_abono[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

FileWrite(li_FileNum,is_SetCondensado + ls_cadena + is_CancelNegrita + is_CancelCondensado)
// is_setNegrita +

// Culmino el documento
FileWrite(li_FileNum, is_FormFeed)

//Cierro el archivo
FileClose(li_FileNum)

if as_flag_ts = '0' then
	this.of_imprimir_local(ls_dir_ts, ls_file )
else
	this.of_imprimir_ts(ls_dir_ts)
end if

destroy lds_data
return true
end function

public function boolean of_voucher_cheque (string as_dw, string as_origen, long al_nro, string as_empresa, string as_flag_ts, string as_print, string as_tipo_imp);//Variables cabecera del voucher
Date				ld_fecha_emision
string			ls_string , ls_run, ls_dir_ts, ls_file, ls_cadena, ls_mensaje 

Long				ll_long, ll_i
Decimal			ldc_decimal
integer 			li_FileNum,li_linea_max,li_count_det ,li_count_ch,li_count_blc,&
					li_pos
u_ds_base	 	lds_data

lds_data	 = create u_ds_base


//print

IF as_print = 'EPSON LX-300' THEN
	li_count_det = 12	
	li_count_ch  = 7
	li_count_blc = 13
ELSE
	li_count_det = 13	
	li_count_ch  = 6
	li_count_blc = 14	
END IF

lds_data.dataobject = as_dw
lds_data.SetTransObject( SQLCA )
lds_data.Retrieve(as_origen, al_nro, as_empresa)

if lds_data.RowCount()= 0 then
	MessageBox('Aviso', 'No hay registro recuperados')
	destroy lds_data
	return false
end if

If SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	destroy lds_data
	return false
end if
if as_flag_ts = '1' then
	ls_dir_ts = '\\tsclient\c\'
else
	ls_dir_ts = 'c:\pb_exe\impresora\'
end if

If Not DirectoryExists ( ls_dir_ts ) Then
	MessageBox ("File Mgr", "Directory " + ls_dir_ts + " no exista" )
	destroy lds_data
	return false
else
End If

ls_file = ls_dir_ts + 'PRUEBA.PRN'

// Edg Begin 04Dic2007
   ls_file = mid(gnvo_app.is_user + string( rand(32767) ), 1, 8) 
	ls_file = ls_dir_ts + ls_file + '.PRN'
// Edg End   04Dic2007

//if FileExists(ls_file) then
//	ls_cadena = ''
//else
	// Activo el nivel de paginas (Cheque Voucher)
	// Activo a 12 CPI
	// Tamaño Asc('0')
	ls_cadena = is_InitialitePrinter + this.of_setpagelines(47) &
				 + is_SetMode12CPI + is_CancelCondensado + is_Set1_6LineSpacing
				 
//	--
//end if
li_FileNum = FileOpen(ls_file, LineMode!, Write!, LockWrite!, Append!)

if li_FileNum = -1 then
	
	MessageBox('Aviso', 'Error al momento de aperturar el archivo')
	destroy lds_data
	return false
end if



//FileWrite(li_FileNum, ls_cadena)  

//************ Armo la cebecera del Voucher *************

// Primera Linea = Empresa + Fecha Emision
ls_cadena = ls_cadena + fill(" ", 9) + left(as_empresa,50) + Fill(" ", 58 - len(as_empresa))
ld_fecha_emision = Date(lds_data.object.fecha_emision[1])
if Not IsNUll(ld_fecha_emision ) then 
	ls_cadena += string(ld_fecha_emision, 'dd/mm/yyyy')
end if

FileWrite(li_FileNum, ls_cadena  + is_LineFeed + is_CancelCondensado)  
//
//FileWrite(li_FileNum, '')  

// Segunda Linea = Nombre Banco + Cod_ctabco + nro_cheque
ls_string = left(lds_data.object.nom_banco [1], 23)
if IsNull(ls_string) then ls_string = fill(" ", 23)
ls_cadena = fill(" ", 6) + ls_string + fill(" ", 30 - len(ls_string))

ls_string = lds_data.object.cod_ctabco[1]
if IsNull(ls_string) then ls_string = fill(" ", 20)
ls_cadena = ls_cadena + ls_string + fill(" ", 33 - len(ls_string))

ls_string = string(lds_data.object.nro_cheque[1])
if IsNull(ls_string) then ls_string = fill(" ", 10)
ls_cadena = ls_cadena + ls_string
FileWrite(li_FileNum, ls_cadena + is_LineFeed )  

// Tercera Linea = AFavor + Voucher
ls_string = left(lds_data.object.afavor [1],49)

//caracter de Ñ
IF len(ls_string) > 0 THEN //REMPLAZAR LA Ñ
	li_pos = Pos(ls_string,'Ñ',1)
	
	do while li_pos > 0
		ls_string = Replace(ls_string,li_pos,1,'¥')
		li_pos = Pos(ls_string,'Ñ',li_pos + 1)		 
	loop
END IF

//inicializacion de li_pos
li_pos = 0
//


if IsNull(ls_string) then ls_string = fill(" ", 49)
ls_cadena = fill(" ", 11) + ls_string + fill(" ", 57 - len(ls_string))

ls_string = lds_data.object.origen[1] + string(lds_data.object.ano[1]) &
			 + string(lds_data.object.mes[1]) + string(lds_data.object.nro_libro[1]) &
			 + string(lds_data.object.nro_asiento[1])
ls_cadena += ls_string
FileWrite(li_FileNum, ls_cadena )  


// Tercera Linea = Tasa Cambio + Total
ls_cadena = fill(" ",50) + is_SetNegrita + "T.CAMBIO    TOTAL" + is_CancelNegrita
FileWrite(li_FileNum, ls_cadena )  

// Tercera Linea = Caja Obs + Tipo Cambio + Total
ls_string = left(lds_data.object.caja_bancos_obs [1], 42)
if IsNull(ls_string) then ls_string = fill(" ", 42)
ls_cadena = fill(" ", 8) + ls_string + fill(" ", 45 - len(ls_string))

ls_string = string(lds_data.object.tasa_cambio[1], "###,##0.000") &
			 + fill(" ", 4) + lds_data.object.cod_moneda[1] &
			 + string(lds_data.object.imp_total[1], "###,##0.00")
			 
if IsNull(ls_string) then ls_string = fill(" ", 14)
ls_cadena += ls_string

FileWrite(li_FileNum, ls_cadena + is_LineFeed)  

// ******************************************************

// Activo el condensado
FileWrite(li_FileNum, is_SetCondensado )  

//Imprimo cada una de las lineas
li_linea_max = lds_data.RowCount()

 
if li_linea_max > li_count_det then
	li_linea_max = li_count_det
end if


for ll_i = 1 to li_linea_max 
	//lds_data.RowCount()
	ls_cadena = ''
	ls_string = left(lds_data.object.cencos[ll_i],7)
	if ISNull(ls_string) then ls_string = fill(' ', 7)
	ls_cadena = ls_string + fill(' ', 11 - len(ls_string))

	ls_string = lds_data.object.cnta_ctbl [ll_i]
	if ISNull(ls_string) then ls_string = fill(" ", 10)
	ls_cadena = ls_cadena + ls_string + fill(' ', 13 - len(ls_string))
	
	ls_string = lds_data.object.cod_relacion[ll_i]
	if ISNull(ls_string) then ls_string = fill(" ", 8)
	ls_cadena = ls_cadena + ls_string + fill(' ', 12 - len(ls_string))
	
	ls_string = left(lds_data.object.tipo_docref1[ll_i],4)
	if ISNull(ls_string) then ls_string = fill(" ", 4)
	ls_cadena = ls_cadena + ls_string + fill(' ', 8 - len(ls_string))

	ls_string = left(lds_data.object.nro_docref1[ll_i],15)
	if ISNull(ls_string) then ls_string = fill(" ", 15)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.soles_cargo[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.soles_abono[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

	ls_string = f_llena_caracteres(' ', string(lds_data.object.dolares_cargo[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))
	
	ls_string = f_llena_caracteres(' ', string(lds_data.object.dolares_abono[ll_i], '###,###0.00'), 10)
	if ISNull(ls_string) then ls_string = fill(" ", 17)
	ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

	FileWrite(li_FileNum, ls_cadena )
	
next

// Ingreso varias lineas en Blanco
for ll_i = 1 to li_count_blc - li_linea_max
	FileWrite(li_FileNum, '' )
next


// Coloco la Linea de Resultados Totales
ls_cadena = Fill(" ", 64)

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_soles_cargo[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_soles_abono[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 20 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_dolares_cargo[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

ls_string = f_llena_caracteres(' ', string(lds_data.object.total_dolares_abono[1], '###,###0.00'), 10)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string + fill(' ', 18 - len(ls_string))

//FileWrite(li_FileNum, is_setNegrita +  ls_cadena + is_CancelCondensado  + is_CancelNegrita )
FileWrite(li_FileNum, ls_cadena +  is_CancelNegrita + is_CancelCondensado )

// Ingreso varias lineas en Blanco
//for ll_i = 1 to 1
//	 FileWrite(li_FileNum, is_Set1_8LineSpacing + '' )
//next

for ll_i = 1 to li_count_ch 
	FileWrite(li_FileNum, is_Set1_6LineSpacing + '' )
next


ls_cadena = Fill(" ", 43)
//42
// Coloco los datos del Cheque
ls_string = string(lds_data.object.ano_c[1]) + "  " &
			 + string(lds_data.object.mes_c[1]) + "  " &
			 + string(lds_data.object.dia[1] ) 
if ISNull(ls_string) then ls_string = fill(" ", 12)
//12
ls_cadena = ls_cadena + ls_string + fill(' ', 22 - len(ls_string))
//23

ls_string = right(lds_data.object.total_c[1], 15)
if ISNull(ls_string) then ls_string = fill(" ", 17)
ls_cadena = ls_cadena + ls_string 

FileWrite(li_FileNum, ls_cadena + fill(is_lineFeed, 3))


ls_string = string(lds_data.object.afavor_1[1])
//caracter de Ñ
IF len(ls_string) > 0 THEN //REMPLAZAR LA Ñ
	li_pos = Pos(ls_string,'Ñ',1)
	
	do while li_pos > 0
		ls_string = Replace(ls_string,li_pos,1,'¥')
		li_pos = Pos(ls_string,'Ñ',li_pos + 1)		 
	loop
END IF

ls_cadena = fill( " ", 13) + ls_string 

FileWrite(li_FileNum, ls_cadena + is_lineFeed )

ls_string = string(lds_data.object.total_letras[1])
ls_cadena = fill( " ", 3) + ls_string 

FileWrite(li_FileNum, ls_cadena )


// Culmino el documento
FileWrite(li_FileNum, is_FormFeed)

//Cierro el archivo
FileClose(li_FileNum)

if as_flag_ts = '0' and as_tipo_imp <> 'M' then
	this.of_imprimir_local(ls_dir_ts, ls_file )
elseif as_tipo_imp <> 'M' then
	this.of_imprimir_ts(ls_dir_ts)
end if



destroy lds_data
return true
end function

public function integer of_imprimir_local (string as_dir, string as_archivo);string ls_run
string ls_archivo
if isnull( as_archivo ) then
	ls_archivo = ""
else
	// el ls_archivo viene con el path (as_dir) incluido
	ls_archivo = mid( as_archivo, lastpos( as_archivo, "\"))
end if

ls_run = as_dir + "PRINT.BAT" + " " + ls_archivo
if run(ls_run, Minimized!) = -1 then
	MessageBox('Error', 'Hubo un error tratando de ejecutar el comando ' + ls_run)
	return 0
end if

sleep(13)

return 1
end function

on n_cst_impresion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_impresion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

