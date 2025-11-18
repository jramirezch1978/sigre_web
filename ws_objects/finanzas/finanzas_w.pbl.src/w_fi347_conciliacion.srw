$PBExportHeader$w_fi347_conciliacion.srw
forward
global type w_fi347_conciliacion from w_abc
end type
type st_12 from statictext within w_fi347_conciliacion
end type
type st_11 from statictext within w_fi347_conciliacion
end type
type pb_5 from picturebutton within w_fi347_conciliacion
end type
type pb_4 from picturebutton within w_fi347_conciliacion
end type
type st_10 from statictext within w_fi347_conciliacion
end type
type st_9 from statictext within w_fi347_conciliacion
end type
type st_8 from statictext within w_fi347_conciliacion
end type
type st_7 from statictext within w_fi347_conciliacion
end type
type pb_2 from picturebutton within w_fi347_conciliacion
end type
type cb_2 from commandbutton within w_fi347_conciliacion
end type
type dw_2 from u_dw_abc within w_fi347_conciliacion
end type
type dw_1 from u_dw_abc within w_fi347_conciliacion
end type
type pb_compara from picturebutton within w_fi347_conciliacion
end type
type dw_texto from u_dw_abc within w_fi347_conciliacion
end type
type pb_transfer from picturebutton within w_fi347_conciliacion
end type
type em_saldo_concil from editmask within w_fi347_conciliacion
end type
type em_saldo_cnta from editmask within w_fi347_conciliacion
end type
type cb_1 from commandbutton within w_fi347_conciliacion
end type
type st_6 from statictext within w_fi347_conciliacion
end type
type st_5 from statictext within w_fi347_conciliacion
end type
type em_mes from editmask within w_fi347_conciliacion
end type
type st_4 from statictext within w_fi347_conciliacion
end type
type st_3 from statictext within w_fi347_conciliacion
end type
type st_2 from statictext within w_fi347_conciliacion
end type
type pb_3 from picturebutton within w_fi347_conciliacion
end type
type pb_procesa from picturebutton within w_fi347_conciliacion
end type
type em_ano from editmask within w_fi347_conciliacion
end type
type sle_ctabco from singlelineedit within w_fi347_conciliacion
end type
type pb_1 from picturebutton within w_fi347_conciliacion
end type
type st_1 from statictext within w_fi347_conciliacion
end type
type gb_1 from groupbox within w_fi347_conciliacion
end type
type dw_master from u_dw_abc within w_fi347_conciliacion
end type
end forward

global type w_fi347_conciliacion from w_abc
integer width = 4302
integer height = 2396
string title = "[FI347] Conciliacion Bancaria"
string menuname = "m_consulta_sort"
st_12 st_12
st_11 st_11
pb_5 pb_5
pb_4 pb_4
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
pb_2 pb_2
cb_2 cb_2
dw_2 dw_2
dw_1 dw_1
pb_compara pb_compara
dw_texto dw_texto
pb_transfer pb_transfer
em_saldo_concil em_saldo_concil
em_saldo_cnta em_saldo_cnta
cb_1 cb_1
st_6 st_6
st_5 st_5
em_mes em_mes
st_4 st_4
st_3 st_3
st_2 st_2
pb_3 pb_3
pb_procesa pb_procesa
em_ano em_ano
sle_ctabco sle_ctabco
pb_1 pb_1
st_1 st_1
gb_1 gb_1
dw_master dw_master
end type
global w_fi347_conciliacion w_fi347_conciliacion

forward prototypes
public subroutine wf_verificacion_texto (string as_ctabco, long al_ano, long al_mes)
public function boolean wf_insert_texto ()
end prototypes

public subroutine wf_verificacion_texto (string as_ctabco, long al_ano, long al_mes);Long ll_count
String  ls_colname[],ls_coltype[]
String  ls_coln,ls_colt,ls_valor,ls_col,ls_cadena
Long    ll_inicio
Integer li_totcol,li_x




li_totcol = Integer(dw_texto.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_coln   			= "#" + String(li_x) + ".dbName"
	ls_colname [li_x] = dw_texto.Describe(ls_coln)
	ls_colt   			= "#" + String(li_x) + ".coltype"
	ls_coltype [li_x] = dw_texto.Describe(ls_colt)
NEXT


//verificacion de registros

for ll_inicio = 1 to dw_texto.Rowcount()
	
	 ls_cadena = ''
	 
	 for li_x = 1 to UpperBound(ls_colname)
		  ls_col = Mid(ls_colname[li_x],Pos(ls_colname[li_x] ,'.') + 1)
		  
		  if trim(ls_col) <> 'conciliacion' then
			  if Mid(ls_coltype[li_x],1,3) = 'dec' then
				  ls_valor = Trim(String(dw_texto.GetItemNumber(ll_inicio,ls_col)))
			  else
				  ls_valor = Trim(dw_texto.GetItemString(ll_inicio,ls_col))
			  end if
		  end if
		
	  	  ls_cadena = ls_cadena  + ls_valor
		  
	 next	
	 
	 //conciliacion
	 ls_valor = Trim(dw_texto.GetItemString(ll_inicio,'conciliacion'))


	 select count(*) into :ll_count from fin_conc_txt_log
	   where (cod_ctabco = :as_ctabco ) and
 		      (ano			 = :al_ano	 ) and
		 		(mes			 = :al_mes	 ) and
				(flag_concil  = '1'		 ) and 
		 		(rtrim(ltrim(cadena_txt)) = :ls_cadena) ;
				 
				 
	 
	 if ll_count > 0 then //registro conciliado en archivo texto
		 dw_texto.object.conciliacion [ll_inicio]  = '1'
		 dw_texto.ii_update = 1
	 end if
next	
end subroutine

public function boolean wf_insert_texto ();String  ls_colname[],ls_coltype[]
String  ls_coln,ls_colt,ls_valor,ls_col,ls_cadena,ls_cod_ctabco,ls_msj_err
Long    ll_inicio,ll_ano,ll_mes
Integer li_totcol,li_x
Boolean lb_ret = TRUE

/*Datos de Conciliación*/
ls_cod_ctabco = Trim(sle_ctabco.text)
ll_ano		  = Long(em_ano.text)
ll_mes		  = Long(em_mes.text)


IF Isnull(ls_cod_ctabco) OR Trim(ls_cod_ctabco) = '' THEN
	Messagebox('Aviso','Debe Ingresar Cuenta de Banco , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF

IF Isnull(ll_ano) THEN
	Messagebox('Aviso','Debe Ingresar Año de Proceso , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF

IF Isnull(ll_mes) THEN
	Messagebox('Aviso','Debe Ingresar Mes de Proceso , Verifique!')
	lb_ret = FALSE
	GOTO SALIDA
END IF


/*elimina informacion anterior*/
delete from fin_conc_txt_log
where (cod_ctabco = :ls_cod_ctabco ) and
      (ano			= :ll_ano	 	  ) and
 		(mes			= :ll_mes	 	  ) ;
/**/

li_totcol = Integer(dw_texto.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_coln   			= "#" + String(li_x) + ".dbName"
	ls_colname [li_x] = dw_texto.Describe(ls_coln)
	ls_colt   			= "#" + String(li_x) + ".coltype"
	ls_coltype [li_x] = dw_texto.Describe(ls_colt)
NEXT


for ll_inicio = 1 to dw_texto.Rowcount()
	
	 ls_cadena = ''
	 
	 for li_x = 1 to UpperBound(ls_colname)
		  ls_col = Mid(ls_colname[li_x],Pos(ls_colname[li_x] ,'.') + 1)

		  if Trim(ls_col) <> 'conciliacion' then
			  if Mid(ls_coltype[li_x],1,3) = 'dec' then
				  ls_valor = Trim(String(dw_texto.GetItemNumber(ll_inicio,ls_col)))
			  else
				  ls_valor = Trim(dw_texto.GetItemString(ll_inicio,ls_col))
			  end if
		  end if
		  
		  ls_cadena = ls_cadena  + ls_valor
		  
		  
	 next	
	 
	 //conciliacion
	 ls_valor = Trim(dw_texto.GetItemString(ll_inicio,'conciliacion'))


	 
    Insert Into fin_conc_txt_log
	 (cod_ctabco,ano,mes,item,cadena_txt,flag_concil)
	 Values
	 (:ls_cod_ctabco,:ll_ano,:ll_mes,:ll_inicio,:ls_cadena,:ls_valor);
	 
	 IF SQLCA.SQLCode = -1 THEN 
		 ls_msj_err =  SQLCA.SQLErrText
		 Rollback;		 
       MessageBox('SQL error',ls_msj_err)
	 END IF
	 
next	



SALIDA:


RETURN lb_ret
end function

on w_fi347_conciliacion.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_sort" then this.MenuID = create m_consulta_sort
this.st_12=create st_12
this.st_11=create st_11
this.pb_5=create pb_5
this.pb_4=create pb_4
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.pb_2=create pb_2
this.cb_2=create cb_2
this.dw_2=create dw_2
this.dw_1=create dw_1
this.pb_compara=create pb_compara
this.dw_texto=create dw_texto
this.pb_transfer=create pb_transfer
this.em_saldo_concil=create em_saldo_concil
this.em_saldo_cnta=create em_saldo_cnta
this.cb_1=create cb_1
this.st_6=create st_6
this.st_5=create st_5
this.em_mes=create em_mes
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.pb_3=create pb_3
this.pb_procesa=create pb_procesa
this.em_ano=create em_ano
this.sle_ctabco=create sle_ctabco
this.pb_1=create pb_1
this.st_1=create st_1
this.gb_1=create gb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_12
this.Control[iCurrent+2]=this.st_11
this.Control[iCurrent+3]=this.pb_5
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.st_10
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.st_8
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.dw_2
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.pb_compara
this.Control[iCurrent+14]=this.dw_texto
this.Control[iCurrent+15]=this.pb_transfer
this.Control[iCurrent+16]=this.em_saldo_concil
this.Control[iCurrent+17]=this.em_saldo_cnta
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.st_6
this.Control[iCurrent+20]=this.st_5
this.Control[iCurrent+21]=this.em_mes
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.st_3
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.pb_3
this.Control[iCurrent+26]=this.pb_procesa
this.Control[iCurrent+27]=this.em_ano
this.Control[iCurrent+28]=this.sle_ctabco
this.Control[iCurrent+29]=this.pb_1
this.Control[iCurrent+30]=this.st_1
this.Control[iCurrent+31]=this.gb_1
this.Control[iCurrent+32]=this.dw_master
end on

on w_fi347_conciliacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.pb_5)
destroy(this.pb_4)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.pb_2)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.pb_compara)
destroy(this.dw_texto)
destroy(this.pb_transfer)
destroy(this.em_saldo_concil)
destroy(this.em_saldo_cnta)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.em_mes)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.pb_3)
destroy(this.pb_procesa)
destroy(this.em_ano)
destroy(this.sle_ctabco)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.height 	= newheight - dw_master.y - 10
dw_texto.width  	= newwidth  - dw_texto.x - 10
dw_texto.height 	= newheight - dw_texto.y - 10

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

type st_12 from statictext within w_fi347_conciliacion
integer x = 9
integer y = 464
integer width = 1019
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "5.-Marcar Todo los Movimientos"
boolean focusrectangle = false
end type

type st_11 from statictext within w_fi347_conciliacion
integer x = 901
integer y = 68
integer width = 96
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "5.-"
boolean focusrectangle = false
end type

type pb_5 from picturebutton within w_fi347_conciliacion
integer x = 1015
integer y = 52
integer width = 101
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "EditStops5!"
alignment htextalign = left!
end type

event clicked;Long ll_inicio


for ll_inicio = 1 to dw_master.Rowcount()
	 dw_master.object.ind_concil [ll_inicio] = '1'
	 dw_master.ii_update = 1
next	
end event

type pb_4 from picturebutton within w_fi347_conciliacion
integer x = 782
integer y = 52
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom094!"
alignment htextalign = left!
end type

event clicked;String ls_cta_bco
Long   ll_ano,ll_mes
str_parametros ls_param



ls_cta_bco = sle_ctabco.text
ll_ano	  = Long(em_ano.text)
ll_mes 	  = Long(em_mes.text)	

/*IF dw_master.ii_update = 1 or dw_texto.ii_update = 1 THEN
	Messagebox('Aviso','Debe grabar Modificaciones')
	Return
END IF*/



IF Isnull(ls_cta_bco) OR Trim(ls_cta_bco) = '' THEN
	Messagebox('Aviso','Debe Haber Ingresado Alguna Cuenta de Banco')
	Return
END IF

IF Isnull(ll_ano) THEN
	Messagebox('Aviso','Debe Haber Ingresar Año de Proceso')
	Return
END IF

IF Isnull(ll_mes) THEN
	Messagebox('Aviso','Debe Haber Ingresar Mes de Proceso')
	Return
END IF


ls_param.string1  = ls_cta_bco
ls_param.longa[1] = ll_ano
ls_param.longa[2] = ll_mes

OpenSheetWithParm(w_fi351_conciliacion_no_registrado,ls_param,parent,1,original!)


end event

type st_10 from statictext within w_fi347_conciliacion
integer x = 695
integer y = 68
integer width = 69
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "4.-"
boolean focusrectangle = false
end type

type st_9 from statictext within w_fi347_conciliacion
integer x = 9
integer y = 392
integer width = 1554
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "4.-Eliminación de Movimientos no encontrados en el Sistema"
boolean focusrectangle = false
end type

type st_8 from statictext within w_fi347_conciliacion
integer x = 9
integer y = 320
integer width = 1202
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "3.- Reporte de Conciliación Bancaria"
boolean focusrectangle = false
end type

type st_7 from statictext within w_fi347_conciliacion
integer x = 489
integer y = 68
integer width = 69
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "3.-"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_fi347_conciliacion
integer x = 576
integer y = 52
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Report!"
alignment htextalign = left!
end type

event clicked;String ls_cta_bco
Long   ll_ano,ll_mes
str_parametros ls_param

ls_cta_bco = sle_ctabco.text
ll_ano	  = Long(em_ano.text)
ll_mes 	  = Long(em_mes.text)	

/*IF dw_master.ii_update = 1 or dw_texto.ii_update = 1 THEN
	Messagebox('Aviso','Debe grabar Modificaciones')
	Return
END IF*/



IF Isnull(ls_cta_bco) OR Trim(ls_cta_bco) = '' THEN
	Messagebox('Aviso','Debe Haber Ingresado Alguna Cuenta de Banco')
	Return
END IF

IF Isnull(ll_ano) THEN
	Messagebox('Aviso','Debe Haber Ingresar Año de Proceso')
	Return
END IF

IF Isnull(ll_mes) THEN
	Messagebox('Aviso','Debe Haber Ingresar Mes de Proceso')
	Return
END IF


ls_param.string1  = ls_cta_bco
ls_param.longa[1] = ll_ano
ls_param.longa[2] = ll_mes

OpenSheetWithParm(w_fi727_conciliacion_bancaria,ls_param,parent,1,layered!)


end event

type cb_2 from commandbutton within w_fi347_conciliacion
boolean visible = false
integer x = 2208
integer y = 268
integer width = 745
integer height = 160
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "procesio de saldo bancario mensual"
end type

event clicked;Long ll_ano,ll_mes,ll_ano_ant,ll_mes_ant


ll_ano = Long(em_ano.text)
ll_mes = Long(em_mes.text)

IF ll_mes = 1 THEN
	ll_mes_ant = 12
	ll_ano_ant = ll_ano - 1
ELSE
	ll_mes_ant = ll_mes - 1
	ll_ano_ant = ll_ano 
END IF	




DECLARE PB_USP_FIN_SALDO_BANCOS PROCEDURE FOR USP_FIN_SALDO_BANCOS
(:ll_ano,:ll_mes,:ll_ano_ant,:ll_mes_ant);
EXECUTE PB_USP_FIN_SALDO_BANCOS ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Error de Actualización de Saldos de Bancos Mensuales', SQLCA.SQLErrText)
	Return
END IF

Messagebox('Aviso','Proceso de Actualizacion Ha Concluido Satisfactoriamente')
end event

type dw_2 from u_dw_abc within w_fi347_conciliacion
boolean visible = false
integer x = 3657
integer y = 72
integer width = 82
integer height = 68
integer taborder = 140
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_2
//idw_det  =  				// dw_detail
end event

type dw_1 from u_dw_abc within w_fi347_conciliacion
boolean visible = false
integer x = 3762
integer y = 52
integer width = 91
integer height = 88
integer taborder = 50
string dataobject = "d_abc_tt_conciliar_envio_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_1
//idw_det  =  				// dw_detail
end event

type pb_compara from picturebutton within w_fi347_conciliacion
integer x = 2647
integer y = 20
integer width = 457
integer height = 236
integer taborder = 30
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Comparar"
string picturename = "c:\sigre\resources\Gif\comparacion.gif"
end type

event clicked;String  ls_flag_util_ope ,ls_formula_int  ,ls_formula_ext ,ls_campo_int,ls_valor_c,ls_valor_ext,ls_valor_int,&
		  ls_desc_oper		 ,ls_formula_final,ls_tipo_col    ,ls_tipo_dato,ls_cod_banco,ls_oper
String  ls_util_ope [],ls_form_int [],ls_form_ext [],ls_camp_int [],ls_des_oper[] ,ls_tip_dato[]
Integer li_arr
Long    ll_inicio,ll_arr,ll_inicio_mast
str_parametros sl_param



	 
IF dw_texto.rowcount( ) = 0 THEN
	Messagebox('Aviso','Recupere Información de Archivo de Texto')
	Return
END IF

//codigo de banco
ls_cod_banco = dw_master.object.banco_cnta_cod_banco [1]



OpenWithParm(w_datos_comparar,ls_cod_banco)

/* verificacion de parametros */
ls_oper = message.StringParm

//**//
 
if Isnull(ls_oper) or Trim(ls_oper) = '' then
	Messagebox('Aviso','Debe Seleccionar un Tipo de Operación')
	Return
end if

li_arr = 1



//CURSOR DE ESTRUCTURA DE 
DECLARE estruct_file CURSOR FOR
select fd.flag_util_oper,fd.formula_dato_int,fd.formula_dato_ext,fd.campo_comparar,fo.descripcion,fd.formula_tipo_dato
  from fin_tipoper_banc_par fc,fin_tipoper_banc_par_det fd,fin_banco_oper fo
 where (fc.cod_banco = fd.cod_banco ) and
 		 (fc.oper  		= fd.oper  		) and
		 (fo.oper      = fd.oper      ) and
		 (fc.cod_banco = :ls_cod_banco) and
		 (fc.oper		= :ls_oper		)
order by fd.oper,fd.item ;


/*Abrir Cursor*/		  	
OPEN estruct_file ;
	
	DO 				/*Recorro Cursor*/	
	 FETCH estruct_file INTO :ls_flag_util_ope,:ls_formula_int,:ls_formula_ext,:ls_campo_int,:ls_desc_oper ,:ls_tipo_dato;
	 
	 IF sqlca.sqlcode = 100 THEN EXIT
	 

	 
	 /**Inserción de Arreglo**/ 
	 ls_util_ope [li_arr] = ls_flag_util_ope
	 ls_form_int [li_arr] = ls_formula_int
	 ls_form_ext [li_arr] = ls_formula_ext
	 ls_camp_int [li_arr] = ls_campo_int
	 ls_des_oper [li_arr] = ls_desc_oper
	 ls_tip_dato [li_arr] = ls_tipo_dato
	 li_arr = li_arr + 1
	 
	LOOP WHILE TRUE
	
CLOSE estruct_file ; /*Cierra Cursor*/


IF UpperBound(ls_util_ope) = 0 THEN
	Messagebox('Aviso','Operación No tiene Formula ,Verifique! ')
	Return
END IF

/**/
dw_1.Reset()
dw_2.Reset()

//detalle de texto
For ll_inicio = 1 to dw_texto.Rowcount( )
	
	 ls_formula_final = ''
	 //comparacion de archivo texto
	 
	 for ll_arr = 1 to UpperBound(ls_util_ope)
		  if ls_util_ope [ll_arr] = '1' then //UTILIZAR DATOS A COMPARAR SEGUN OPERACION
		  	  ls_valor_ext = dw_texto.Describe("evaluate('" + ls_form_ext [ll_arr] +"',"+	String(ll_inicio) + ")")
			  
			  if ls_valor_ext = ls_des_oper [ll_arr] then
				
				  if Trim(ls_formula_final) = '' then
				  	  ls_formula_final = ls_formula_final + ls_camp_int [ll_arr] +' = '+ls_form_int [ll_arr]
				  else	
					  ls_formula_final = ls_formula_final +' and '+ ls_camp_int [ll_arr]+' = '+ls_form_int [ll_arr]
				  end if	
			  else	  
				  GOTO SALIDA
			  end if
			  
		  else
			  ls_valor_ext = dw_texto.Describe("evaluate('" + ls_form_ext [ll_arr] +"',"+	String(ll_inicio) + ")")
			  
			  if ls_tip_dato [ll_arr] = 'C' then //tipo de dato char
			  	  ls_valor_ext = '"' +trim(ls_valor_ext)+'"'
			  end if	 
			  
			  
			  if Trim(ls_formula_final) = '' then
				  ls_formula_final = ls_formula_final + ls_camp_int [ll_arr] +' = '+ls_valor_ext
			  else	
				  ls_formula_final = ls_formula_final +' and '+ ls_camp_int [ll_arr]+' = '+ls_valor_ext
			  end if	
		  end if
		  
	 next

	 String ls_exp_eval,ls_voucher
	 
	 
	 //detalle de movimientos
	 For ll_inicio_mast = 1 to dw_master.rowcount( )

		  ls_exp_eval  = "evaluate('if (" + ls_formula_final +",1,0)',"+String(ll_inicio_mast)+")"				  
		  ls_voucher   = dw_master.object.voucher [ll_inicio_mast]
  		  ls_valor_ext = dw_master.Describe(ls_exp_eval)				
			 	
		  IF ls_valor_ext = '1' THEN
			  //base dedatos propia
			  dw_master.RowsMove(ll_inicio_mast,ll_inicio_mast, Primary!, dw_1, 1, Primary!)
			  
			  //crear dw temporal
			  if dw_2.Rowcount() = 0 then
				  f_create_dw(ls_cod_banco,dw_2)
			  end if

			  //archivo texto			  
			  dw_texto.RowsMove (ll_inicio,ll_inicio, Primary!, dw_2, 1, Primary!)
			  

			  
		  else	  
			  parent.SetMicroHelp(ls_voucher)
		  END IF	
					 
    Next
	 
	 SALIDA:	 
	 
Next
		 
IF dw_1.Rowcount() > 0 OR dw_2.Rowcount() > 0 THEN
	sl_param.dw_m = dw_1 //archivo origen
	sl_param.dw_d = dw_2 //archivo texto
	
	OpenWithParm(w_fi348_conciliacion_automatic, sl_param)
	
	if sl_param.dw_m.rowcount( ) > 0 or sl_param.dw_d.rowcount( ) > 0 then
		sl_param.dw_m.RowsMove (1,sl_param.dw_m.rowcount(), Primary!, dw_master, 1, Primary!)		
		sl_param.dw_d.RowsMove (1,sl_param.dw_d.rowcount(), Primary!, dw_texto, 1, Primary!)		
		
		dw_master.ii_update = 1
		dw_texto.ii_update  = 1
		//reordenamiento
		dw_master.Sort()
		dw_texto.Sort()
		
		//reagrupamiento
		dw_master.GroupCalc()
		dw_texto.GroupCalc()
	end if	
	
END IF

dw_1.Reset()
dw_2.Reset()

dw_1.Accepttext()
dw_2.Accepttext()

end event

type dw_texto from u_dw_abc within w_fi347_conciliacion
integer x = 2830
integer y = 536
integer width = 1426
integer height = 1632
integer taborder = 110
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_texto
//idw_det  =  				// dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext ()

end event

type pb_transfer from picturebutton within w_fi347_conciliacion
integer x = 2167
integer y = 20
integer width = 457
integer height = 236
integer taborder = 50
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transferir Archivo"
string picturename = "c:\sigre\resources\jpg\transferencia.JPG"
end type

event clicked;Integer li_file_open,li_nro_linea,li_fil_pos,li_col_pos,li_longitud_cadena,li_file_read,&
		  li_arr
String  ls_cadena_input,ls_form_imp,ls_tipo,ls_cod_banco,ls_cta_banco
Integer li_fila_pos  [],li_col_posi[],li_long_cad[]
String  ls_nom_colum [],ls_for_imp[]
Long    ll_inicio ,li_new_pos_one ,li_new_pos_two ,li_pos_car_one,li_pos_car_two,&
		  ll_ano		,ll_mes
String  ls_cadena ,ls_valores     ,ls_valor
String  ls_filename, ls_fullname


/*Buscar Archivo*/
if GetFileOpenName ("Open", ls_fullname, ls_filename, "txt", "Text Files (*.txt),*.txt ", &
									"i:\pb_exe\txt\", 512) < 1 then
									
	GOTO SALIDA
end if									
/**/



li_arr  = 1

dw_master.Accepttext( )

//recupero datos de cuenta de banco
if dw_master.Rowcount() = 0 then
	Messagebox('Aviso','No Existen Movimientos Bancarios Registrados en el Sistema , Verifique!')
	Return
end if

//ELIMINA INFORMACION TTEMPORAL
delete from tt_fin_conc ;

//datos de banco
ls_cod_banco = dw_master.object.banco_cnta_cod_banco [1]
ls_cta_banco = Trim(sle_ctabco.text)
ll_ano		 = Long(em_ano.text)
ll_mes		 = Long(em_mes.text)


IF Isnull(ls_cta_banco) OR Trim(ls_cta_banco) = '' THEN
	Messagebox('Aviso','Debe Ingresar Alguna Cuenta de Banco ,Verifique!')
	Return
END IF

IF Isnull(ll_ano) OR ll_ano = 0 THEN
	Messagebox('Aviso','Debe Ingresar Año a Procesar ,Verifique!')
	Return
END IF

IF Isnull(ll_mes) OR ll_mes = 0 THEN
	Messagebox('Aviso','Debe Ingresar Mes a Procesar ,Verifique!')
	Return
END IF



//CURSOR DE ESTRUCTURA DE 
DECLARE estruct_file CURSOR FOR
  SELECT Nvl(fila_pos,0),Nvl(col_pos_ini,0),Nvl(long_cadena,0),formula_imp
  	 FROM fin_imp_file_par 
	WHERE (flag_dw in ('1','2')      ) and
			(cod_banco = :ls_cod_banco )
ORDER BY item ;


/*Abrir Cursor*/		  	
OPEN estruct_file ;
	
	DO 				/*Recorro Cursor*/	
	 FETCH estruct_file INTO :li_fil_pos,:li_col_pos,:li_longitud_cadena,:ls_form_imp;
	 
	 IF sqlca.sqlcode = 100 THEN EXIT
	 

	 
	 /**Inserción de Arreglo**/ 
	 li_fila_pos [li_arr] = li_fil_pos
	 li_col_posi [li_arr] = li_col_pos
	 li_long_cad [li_arr] = li_longitud_cadena 	 
	 ls_for_imp  [li_arr] = ls_form_imp
	 li_arr = li_arr + 1
	 
	LOOP WHILE TRUE
	
CLOSE estruct_file ; /*Cierra Cursor*/


IF Upperbound(li_fila_pos) = 0 THEN 
	Messagebox('Aviso','Banco No Tiene ESTRUCTURA Definida Verifique!')
	GOTO SALIDA
END IF


li_file_open = FileOpen(ls_filename,LineMode!, Read!, Shared!)

if li_file_open = -1 then
	FileClose(li_file_open)
	Return
end if

//inicializacion de linea
li_nro_linea = 1


/*inicilizacion de Valores*/
ls_cadena  = ''
ls_valores = ''
ls_valor   = ''

/*valores para encontrar datos de acuerdo a caracter " "*/
li_pos_car_one = 1
li_pos_car_two = 2


li_file_read = FileRead(li_file_open,ls_cadena_input)

Do While li_file_read <> -100
	
	if li_nro_linea >= li_fila_pos [1] then //VERIFICACION DE POSICION DE FILA DE TXT
	
		For ll_inicio = 1 to UpperBound(li_fila_pos)
			 //recupero informacion
			 if li_long_cad[ll_inicio] = 0 then //NO SE DEFINIO POSICION Y LONGITUD DE CAMPOS
				 if li_col_posi[ll_inicio] = 1 then
					 li_new_pos_two = li_col_posi[ll_inicio]
				 else
					 li_new_pos_two = li_new_pos_two + 1
				 end if
					 
				 li_new_Pos_one = Pos(ls_cadena_input,'"',li_new_pos_two )
				 li_new_Pos_two = Pos(ls_cadena_input,'"',li_new_pos_one + 1 ) 
				 ls_valor = Mid(ls_cadena_input,li_new_pos_one + 1,li_new_pos_two - (li_new_pos_one + 1) )					 
			 else //cuando se define longitud de campos en txt
				 
				 ls_valor = Mid(ls_cadena_input,li_col_posi[ll_inicio],li_long_cad[ll_inicio])
				
			 end if			 

			  
			  
			  ls_tipo  = Lower(ls_for_imp [ll_inicio]) //tipo de columna a grabar

			  //armar insert en parte de columnas			
			  IF Len(ls_cadena) = 0 THEN
				  ls_cadena = 'col_'+ls_tipo+'_'+String(ll_inicio) 
			  ELSE
				  ls_cadena = ls_cadena  + ',col_'+ls_tipo+'_'+String(ll_inicio) 
			  END IF
					
 			  //armar insert en parte de valores a grabar
			  IF Len(ls_valores) = 0 THEN
				  if ls_tipo = 'n' then
					  if Isnull(ls_valor) or Trim(ls_valor) = '' then
						  ls_valor = '0.00'
					  end if	
					  //si valor numerico tiene parentesis los borra						
					  if Pos(ls_valor,'(',li_pos_car_one) > 0 THEN
						  li_pos_car_two = Pos(ls_valor,')',li_pos_car_one + 1 )
					  	  ls_valor = Mid(ls_valor,li_pos_car_one + 1,li_pos_car_two - (li_pos_car_one + 1) )							
					  end if	
					  
					  ls_valores = ls_valores + String(Round(dec(ls_valor),2))
				  else
					  ls_valores = ls_valores +"'"+ ls_valor+"'"	
				  end if	
				  
			  ELSE
				  if ls_tipo = 'n' then
					  if Isnull(ls_valor) or Trim(ls_valor) = '' then
						  ls_valor = '0.00'
					  end if	
					  
					  //si valor numerico tiene parentesis los borra
					  
					  if Pos(ls_valor,'(',li_pos_car_one) > 0 THEN
						  li_pos_car_two = Pos(ls_valor,')',li_pos_car_one + 1 )
					  	  ls_valor = Mid(ls_valor,li_pos_car_one + 1,li_pos_car_two - (li_pos_car_one + 1) )							
					  end if
					  
					  ls_valores = ls_valores +','+ String(Round(dec(ls_valor),2))
				  else
					
					  ls_valores = ls_valores +','+"'"+ ls_valor+"'"						
				  end if		
					  
			  END IF
					
      Next
			
		ls_cadena  = 'Insert Into tt_fin_conc '+'('+ls_cadena+')'+' Values ('+ls_valores+')'
			
		
		EXECUTE IMMEDIATE :ls_cadena ;			
		
	   if SQLCA.SQLCode = -1 THEN 
         MessageBox('SQL error tt_fin_conc', SQLCA.SQLErrText)
		   GOTO SALIDA
		end if
		
	end if //cierra verifacion de linea
		
	//*Reinicializacion de Variables*//
	li_nro_linea = li_nro_linea +1
	ls_cadena	 = ''
	ls_valores	 = ''
	
	//leo archivo texto
	li_file_read = FileRead(li_file_open,ls_cadena_input)
	
Loop


FileClose(li_file_open)



//UNA VEZ CERRADO EL ARCHIVO CREAR DW
IF f_create_dw(ls_cod_banco,dw_texto) = FALSE THEN
	Return
ELSE
	/*Recupera Información*/
	dw_texto.Retrieve()
END IF



/*verificacion de informacion con archivo recuperado*/
wf_verificacion_texto(ls_cta_banco,ll_ano,ll_mes)





SALIDA:
delete from tt_fin_conc ;
Rollback ;
end event

type em_saldo_concil from editmask within w_fi347_conciliacion
integer x = 462
integer y = 808
integer width = 475
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####,###.00"
end type

type em_saldo_cnta from editmask within w_fi347_conciliacion
integer x = 462
integer y = 728
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.00"
end type

type cb_1 from commandbutton within w_fi347_conciliacion
integer x = 946
integer y = 648
integer width = 69
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
Datawindow		 ldw	




lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
								       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
								       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
							 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
								       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN '&
								       +'FROM BANCO_CNTA '
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ctabco.text = lstr_seleccionar.param1[1]
END IF
end event

type st_6 from statictext within w_fi347_conciliacion
integer x = 2830
integer y = 460
integer width = 517
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Archivo Texto"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_fi347_conciliacion
integer x = 617
integer y = 972
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 700
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

type em_mes from editmask within w_fi347_conciliacion
integer x = 462
integer y = 972
integer width = 137
integer height = 72
integer taborder = 130
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
string displaydata = "~t/~t/~t/"
end type

event modified;Long   ll_mes
String ls_mes,ls_null

ll_mes = Long(em_mes.text)


choose case ll_mes
		 case 1
				ls_mes = 'Enero'
		 case 2
				ls_mes = 'Febrero'
		 case 3
				ls_mes = 'Marzo'
		 case 4
				ls_mes = 'Abril'
		 case 5
				ls_mes = 'Mayo'
		 case 6
				ls_mes = 'Junio'
		 case 7
				ls_mes = 'Julio'
		 case 8
				ls_mes = 'Agosto'
		 case 9
				ls_mes = 'Setiembre'
		 case 10
				ls_mes = 'Octubre'
		 case 11
				ls_mes = 'Noviembre'
		 case 12	
				ls_mes = 'Diciembre'
		 case else
				SetNull(ls_mes)
				em_mes.text = ls_mes				
				Messagebox('Aviso','Mes No Existe , Verifique!')
				
				

end choose



st_5.text = ls_mes
end event

type st_4 from statictext within w_fi347_conciliacion
integer x = 261
integer y = 68
integer width = 69
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "2.-"
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi347_conciliacion
integer x = 46
integer y = 68
integer width = 55
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "1.-"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi347_conciliacion
integer x = 9
integer y = 252
integer width = 1202
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "2.- Registrar mov No Encontrados en el Sistema"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_fi347_conciliacion
integer x = 347
integer y = 52
integer width = 123
integer height = 92
integer taborder = 20
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom070!"
end type

event clicked;str_parametros ls_param 
String ls_ctabco,ls_desc_cnta
Long   ll_ano,ll_mes

if Not (is_flag_insertar = '1' or is_flag_modificar = '1')  then
	MessageBox("Error de Acceso", "Su usuario no tiene acceso a modificar o crear concilisaciones", StopSign!)
	return
end if

ls_ctabco = sle_ctabco.text
ll_ano	  = Long(em_ano.text)
ll_mes 	  = Long(em_mes.text)	

if Isnull(ls_ctabco) or trim(ls_ctabco) = '' then
	Messagebox('Aviso','Debe Ingresar Cuenta de Banco ,Verifique!')
	Return	
end if

if Isnull(ll_ano) then
	Messagebox('Aviso','Debe Ingresar Año de Proceso ,Verifique!')
	Return	
end if

if Isnull(ll_mes) then
	Messagebox('Aviso','Debe Ingresar Mes de Proceso ,Verifique!')
	Return	
end if


//if dw_master.Rowcount( ) = 0 then return

ls_desc_cnta = dw_master.object.banco_cnta_descripcion [1]


ls_param.string1 = ls_ctabco
ls_param.string2 = ls_desc_cnta
ls_param.longa   [1] = ll_ano
ls_param.longa   [2] = ll_mes



OpenWithParm(w_fi349_conciliacion_no_registrado,ls_param)
end event

type pb_procesa from picturebutton within w_fi347_conciliacion
integer x = 3118
integer y = 20
integer width = 457
integer height = 236
integer taborder = 60
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar Conciliación"
string picturename = "c:\sigre\resources\jpg\concil.jpeg"
end type

event clicked;Long   	ll_inicio,ll_ano,ll_mes,ll_item,ll_nro_registro
String 	ls_flag_concil , ls_cod_ctabco 	,ls_origen   ,ls_tipo_doc  ,&
		 	ls_nro_doc 	 	, ls_doc_ch		 	,ls_flag_mov ,ls_ind_concil,&
		 	ls_msj_err		, ls_moneda			,ls_obs
Decimal 	ldc_importe	,ldc_saldo_concil, ldc_tasa_cambio
Boolean	lb_ret = TRUE
date		ld_fecha

dwItemStatus ldis_status

ls_cod_ctabco = sle_ctabco.text
ll_ano 		  = Long(em_ano.text)
ll_mes 		  = Long(em_mes.text)

/**/

dw_master.Accepttext( )

IF dw_master.ii_update = 0 THEN
	Messagebox('Aviso','No Ha Realizado Modificaciones, Verifique!')
	RETURN
END IF	



/*DOC CHEQUE*/
select doc_cheque into :ls_doc_ch from finparam where reckey = '1' ;


/*elimina informacion conciliado del mes*/
delete from fin_datos_concil
 where cod_ctabco   = :ls_cod_ctabco 
   and ano 		  	  = :ll_ano		   
	and mes		  	  = :ll_mes			 
	and doc_tipo_conc not in ('3','4') ;

/*encuentra item a conciliar*/
select NVL(max(item), 0)
  into :ll_item 
  from fin_datos_concil 
 where cod_ctabco  = :ls_cod_ctabco 
   and ano			 = :ll_ano		   
	and mes			 = :ll_mes		   ;	 


if isnull(ll_item) then	ll_item = 0

//actualiza saldo de banco en saldo banco mes
ldc_saldo_concil = Round(Dec(em_saldo_concil.text),2)

update saldo_banco_mes
   set saldo_conciliado = :ldc_saldo_concil
 where cod_ctabco = :ls_cod_ctabco	
   and ano			 = :ll_ano			
	and mes			 = :ll_mes			;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText 
	Rollback ;
	MessageBox('SQL error', 'Error en update saldo_banco_mes: ' + ls_msj_err)
	lb_ret = FALSE
	goto salida
END IF

For ll_inicio = 1 to dw_master.Rowcount()
	yield()
	
	ll_item = ll_item + 1
	
	//contador de item
	
	ls_flag_concil  	= dw_master.object.ind_concil   	[ll_inicio]
	ls_origen		  	= dw_master.object.origen		 	[ll_inicio]
	ll_nro_registro 	= dw_master.object.nro_registro 	[ll_inicio]
	ls_tipo_doc	  		= dw_master.object.tipo_doc		[ll_inicio]	
	ls_nro_doc	  	  	= dw_master.object.nro_doc		 	[ll_inicio]
	ldc_importe	  		= dw_master.object.imp_total	 	[ll_inicio]	
	ls_flag_mov	  		= dw_master.object.flag_mov		[ll_inicio]
	ls_moneda			= dw_master.object.cod_moneda		[ll_inicio]
	ls_obs				= dw_master.object.obs				[ll_inicio]
	ld_fecha				= Date(dw_master.object.fecha		[ll_inicio])
	ldc_tasa_cambio	= Dec(dw_master.object.tasa_cambio	[ll_inicio])
	
	if IsNull(ldc_importe) then ldc_importe = 0
	
	if ldc_importe = 0 then
		if MessageBox('Informacion', 'EL importe en el documento ' + ls_tipo_doc + '/' + ls_nro_doc &
			+ ' ubicado en el registro ' + string(ll_nro_registro) + ' tiene importe cero.~r~n' &
			+ '¿Desea corregirlo antes de continuar procesando la conciliación?', Information!, Yesno!, 1) = 1 then
			
			ROLLBACK;
			
			dw_master.SetFocus()
			dw_master.SelectRow(0, false)
			dw_master.SelectRow(ll_inicio, true)
			dw_master.setRow(ll_inicio)
			dw_master.SetColumn('imp_total')
			
			return 
			
		end if
	end if
	 
	if IsNull(ld_fecha) then
		MessageBox('Informacion', 'La Fecha del documento ' + ls_tipo_doc + '/' + ls_nro_doc &
			+ ' ubicado en el registro ' + string(ll_nro_registro) + ' Está vacía.~r~n' &
			+ 'Debe corregirla antes de continuar', Information!)
			
			ROLLBACK;
			
			dw_master.SetFocus()
			dw_master.SelectRow(0, false)
			dw_master.SelectRow(ll_inicio, true)
			dw_master.setRow(ll_inicio)
			dw_master.SetColumn('fecha')
			
			return 
			
	end if

	//Si el usuario decide continuar, pues continuo con el proceso de conciliación
	IF ls_flag_mov = 'E' AND ls_flag_concil = '0' THEN
	 	IF ls_tipo_doc = ls_doc_ch THEN
		 	ls_ind_concil = '2'  //cheques girados y no cobrados
	 	ELSE
			ls_ind_concil = '6'  //egresos pendientes de registro por el banco
	 	END IF
	 
	ELSEIF ls_flag_mov = 'I' AND ls_flag_concil = '0' THEN
	
	 	ls_ind_concil = '5' //Ingresos Pendientes de Registro por el Banco
	 
	ELSEIF ls_flag_concil = '1' THEN
	
	 	ls_ind_concil = '1' //Conciliados Normalmente
	 
	ELSE
		ROLLBACK;
		
	 	Messagebox('Error en estado de Flag_mov','revisar este caso, coordinar con Tesorerí')
		
		return
	END IF	

	insert into fin_datos_concil(
	 	cod_ctabco   	,ano      			,mes     ,item          ,origen  ,
	  	nro_registro 	,tipo_doc 			,nro_doc ,doc_tipo_conc ,cod_usr ,
	  	importe 		 	,flag_replicacion	,obs		,cod_moneda		,tasa_cambio,
		fecha_doc)
	values(
	 	:ls_cod_ctabco 	,:ll_ano      ,:ll_mes      ,:ll_item        ,:ls_origen     ,
		:ll_nro_registro	,:ls_tipo_doc ,:ls_nro_doc  ,:ls_ind_concil 	,:gs_user        ,
		:ldc_importe 		,'1'			  ,:ls_obs		 ,:ls_moneda		,:ldc_tasa_cambio,
		:ld_fecha) ;
		  
		
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText	
		Rollback ;	
		MessageBox("SQL Error en pb_procesa.clicked()", "Error al momento de insertar datos en FIN_DATOS_CONCIL: " + ls_msj_err)
		return
	END IF
	
Next

//grabar informacion de archivo texto
IF dw_texto.ii_update = 1 THEN
	if wf_insert_texto() = false then
		lb_ret = FALSE
	end if
END IF	


salida:
IF lb_ret THEN
	Commit ;
	dw_master.ii_update = 0
	dw_texto.ii_update  = 0
	MessageBox('Aviso', 'Proceso de Conciliación se grabó Satisfactoriamente')
ELSE
	Rollback ;
END IF

end event

type em_ano from editmask within w_fi347_conciliacion
integer x = 462
integer y = 884
integer width = 283
integer height = 72
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type sle_ctabco from singlelineedit within w_fi347_conciliacion
integer x = 462
integer y = 644
integer width = 475
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_fi347_conciliacion
integer x = 119
integer y = 52
integer width = 123
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "SelectReturn!"
alignment htextalign = left!
end type

event clicked;String  ls_cta_bco, ls_mensaje
Integer li_opcion
Long    ll_ano,ll_mes
Decimal ldc_saldo,ldc_saldo_conciliado 

if Not (is_flag_insertar = '1' or is_flag_modificar = '1')  then
	MessageBox("Error de Acceso", "Su usuario no tiene acceso a modificar o crear concilisaciones", StopSign!)
	return
end if

IF dw_master.ii_update = 1 or dw_texto.ii_update = 1 THEN
	li_opcion = Messagebox('Aviso','Desea Descartar Modificaciones ?',Question!,YesNo!,2)
	if li_opcion = 2 then return //no recupera
END IF


ls_cta_bco = sle_ctabco.text
ll_ano	  = Long(em_ano.text)
ll_mes 	  = Long(em_mes.text)	

DECLARE usp_fin_datos_conciliacion PROCEDURE FOR 
	usp_fin_datos_conciliacion(:ls_cta_bco,
										:ll_ano,
										:ll_mes);
EXECUTE usp_fin_datos_conciliacion ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = 'PROCEDURE usp_fin_datos_conciliacion: ' &
					+ SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox("SQL error", ls_mensaje)
	return
END IF


CLOSE usp_fin_datos_conciliacion;

dw_master.Retrieve ()
dw_texto.Reset		 ()

if dw_master.rowcount( ) = 0 then
	Messagebox('Aviso','No Existen Datos , Verifique!')
else
	/*buscar saldo bancario*/
	select saldo,saldo_conciliado 
	  into :ldc_saldo,:ldc_saldo_conciliado 
	  from saldo_banco_mes
	 where (cod_ctabco = :ls_cta_bco ) and
	 		 (ano			 = :ll_ano 		) and
			 (mes			 = :ll_mes	 	) ;
	/**/
	
	em_saldo_cnta.text   = String(ldc_saldo)
	em_saldo_concil.text = String(ldc_saldo_conciliado)
	
end if
	


end event

type st_1 from statictext within w_fi347_conciliacion
integer x = 9
integer y = 184
integer width = 878
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "1.- Recuperar Registros a Conciliar"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_fi347_conciliacion
integer x = 14
integer width = 1189
integer height = 160
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

type dw_master from u_dw_abc within w_fi347_conciliacion
integer x = 14
integer y = 536
integer width = 2807
integer height = 1632
integer taborder = 70
string dataobject = "d_abc_tt_conciliar_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext ()

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master
//idw_det  =  				// dw_detail
end event

