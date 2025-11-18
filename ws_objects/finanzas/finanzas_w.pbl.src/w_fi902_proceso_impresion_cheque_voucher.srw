$PBExportHeader$w_fi902_proceso_impresion_cheque_voucher.srw
forward
global type w_fi902_proceso_impresion_cheque_voucher from w_prc
end type
type lb_1 from listbox within w_fi902_proceso_impresion_cheque_voucher
end type
type rb_terminal from radiobutton within w_fi902_proceso_impresion_cheque_voucher
end type
type rb_local from radiobutton within w_fi902_proceso_impresion_cheque_voucher
end type
type cb_2 from commandbutton within w_fi902_proceso_impresion_cheque_voucher
end type
type st_nom_ctabco from statictext within w_fi902_proceso_impresion_cheque_voucher
end type
type st_3 from statictext within w_fi902_proceso_impresion_cheque_voucher
end type
type st_2 from statictext within w_fi902_proceso_impresion_cheque_voucher
end type
type st_1 from statictext within w_fi902_proceso_impresion_cheque_voucher
end type
type sle_3 from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
end type
type sle_2 from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
end type
type sle_codctabco from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
end type
type cb_1 from commandbutton within w_fi902_proceso_impresion_cheque_voucher
end type
type gb_1 from groupbox within w_fi902_proceso_impresion_cheque_voucher
end type
type gb_2 from groupbox within w_fi902_proceso_impresion_cheque_voucher
end type
end forward

global type w_fi902_proceso_impresion_cheque_voucher from w_prc
integer width = 2587
integer height = 648
string title = "Impresion Masiva Cheque -Voucher (FI902)"
lb_1 lb_1
rb_terminal rb_terminal
rb_local rb_local
cb_2 cb_2
st_nom_ctabco st_nom_ctabco
st_3 st_3
st_2 st_2
st_1 st_1
sle_3 sle_3
sle_2 sle_2
sle_codctabco sle_codctabco
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_fi902_proceso_impresion_cheque_voucher w_fi902_proceso_impresion_cheque_voucher

on w_fi902_proceso_impresion_cheque_voucher.create
int iCurrent
call super::create
this.lb_1=create lb_1
this.rb_terminal=create rb_terminal
this.rb_local=create rb_local
this.cb_2=create cb_2
this.st_nom_ctabco=create st_nom_ctabco
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_codctabco=create sle_codctabco
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_1
this.Control[iCurrent+2]=this.rb_terminal
this.Control[iCurrent+3]=this.rb_local
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_nom_ctabco
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_3
this.Control[iCurrent+10]=this.sle_2
this.Control[iCurrent+11]=this.sle_codctabco
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_fi902_proceso_impresion_cheque_voucher.destroy
call super::destroy
destroy(this.lb_1)
destroy(this.rb_terminal)
destroy(this.rb_local)
destroy(this.cb_2)
destroy(this.st_nom_ctabco)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_codctabco)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type lb_1 from listbox within w_fi902_proceso_impresion_cheque_voucher
integer x = 1243
integer y = 76
integer width = 631
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"EPSON LX-300","EPSON FX-2170","EPSON FX-890"}
borderstyle borderstyle = stylelowered!
end type

type rb_terminal from radiobutton within w_fi902_proceso_impresion_cheque_voucher
integer x = 535
integer y = 92
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terminal Server"
end type

type rb_local from radiobutton within w_fi902_proceso_impresion_cheque_voucher
integer x = 110
integer y = 92
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Local "
end type

type cb_2 from commandbutton within w_fi902_proceso_impresion_cheque_voucher
integer x = 1093
integer y = 232
integer width = 96
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar


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
		sle_codctabco.text = lstr_seleccionar.param1[1]
		st_nom_ctabco.text = lstr_seleccionar.param2[1]
	END IF	
				
end event

type st_nom_ctabco from statictext within w_fi902_proceso_impresion_cheque_voucher
integer x = 1202
integer y = 232
integer width = 1330
integer height = 80
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

type st_3 from statictext within w_fi902_proceso_impresion_cheque_voucher
integer x = 27
integer y = 240
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta de Banco :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi902_proceso_impresion_cheque_voucher
integer x = 965
integer y = 376
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cheque Final :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi902_proceso_impresion_cheque_voucher
integer x = 27
integer y = 376
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cheque Inicio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
integer x = 1431
integer y = 376
integer width = 343
integer height = 80
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

type sle_2 from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
integer x = 558
integer y = 376
integer width = 343
integer height = 80
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

type sle_codctabco from singlelineedit within w_fi902_proceso_impresion_cheque_voucher
event ue_enter pbm_keydown
integer x = 558
integer y = 232
integer width = 512
integer height = 80
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

event ue_enter;Long   ll_count
String ls_ctabco,ls_desc

if key = KeyEnter! then
	ls_ctabco = this.text
	
	select count (*) into :ll_count from banco_cnta where cod_ctabco = :ls_ctabco ;
	
	if ll_count > 0 then
		select descripcion into :ls_desc from banco_cnta 
		 where cod_ctabco = :ls_ctabco ;
		
		st_nom_ctabco.text = ls_desc
		
	else
		Messagebox('Aviso','Cuenta de Banco No Existe')
	end if
end if
end event

type cb_1 from commandbutton within w_fi902_proceso_impresion_cheque_voucher
integer x = 2135
integer y = 24
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Impresión"
end type

event clicked;String ls_codctabco,ls_origen,ls_flag_ts,ls_print,ls_run,ls_dir
Long   ll_cheque_inicio,ll_cheque_final,ll_nro_Registro
n_cst_impresion lnvo_impresion

//declaracion de objecto
lnvo_impresion = create n_cst_impresion


ls_codctabco	  = sle_codctabco.text 
ll_cheque_inicio = Long(sle_2.text)
ll_cheque_final  = Long(sle_3.text)

//nombre de impresora
ls_print = lb_1.SelectedItem()

IF Isnull(ls_print) OR Trim(ls_prinT) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Impresora')
	Return
END IF




IF rb_local.checked THEN
	ls_flag_ts = '0' 	
ELSEIF rb_terminal.checked THEN
	ls_flag_ts = '1' 
END IF

IF Isnull(ls_flag_ts) OR Trim(ls_flag_ts) = '' THEN
	Messagebox('Aviso','Debe Seleccionar tipo de Impresión')
	Return
END IF
	

/*Declaración de Cursor*/
DECLARE cheque CURSOR FOR
 select nro_registro 
   from cheque_emitir
  where (flag_estado = '1'					  ) and
  		  (cod_ctabco  =  :ls_codctabco    ) and
  		  (nro_cheque >= :ll_cheque_inicio ) and
		  (nro_cheque <= :ll_cheque_final  ) 
order by nro_cheque ;
					

/*Abrir Cursor*/		  	
OPEN cheque ;

	
	DO 				/*Recorro Cursor*/	
	 FETCH cheque INTO :ll_nro_registro ;
	 IF sqlca.sqlcode = 100 THEN EXIT
	 	/*IMPRESION LOCAL O TERMINAL SERVER*/
		select origen,nro_registro into :ls_origen,:ll_nro_registro from caja_bancos where reg_cheque = :ll_nro_registro ;
		
		 
		lnvo_impresion.of_voucher_cheque ('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa,ls_flag_ts,ls_print,'P')

	 
	 
	LOOP WHILE TRUE
	
CLOSE cheque ; /*Cierra Cursor*/

destroy lnvo_impresion



end event

type gb_1 from groupbox within w_fi902_proceso_impresion_cheque_voucher
integer x = 50
integer y = 20
integer width = 1088
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresión"
end type

type gb_2 from groupbox within w_fi902_proceso_impresion_cheque_voucher
integer x = 1211
integer y = 20
integer width = 699
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona Impresora"
end type

