$PBExportHeader$w_pt911_aprueba_partida_prsp.srw
forward
global type w_pt911_aprueba_partida_prsp from w_abc
end type
type st_9 from statictext within w_pt911_aprueba_partida_prsp
end type
type st_cencos from statictext within w_pt911_aprueba_partida_prsp
end type
type st_5 from statictext within w_pt911_aprueba_partida_prsp
end type
type st_4 from statictext within w_pt911_aprueba_partida_prsp
end type
type em_cnta_prsp from editmask within w_pt911_aprueba_partida_prsp
end type
type em_cencos from editmask within w_pt911_aprueba_partida_prsp
end type
type st_7 from statictext within w_pt911_aprueba_partida_prsp
end type
type cbx_rev from checkbox within w_pt911_aprueba_partida_prsp
end type
type em_ano from editmask within w_pt911_aprueba_partida_prsp
end type
type st_6 from statictext within w_pt911_aprueba_partida_prsp
end type
type st_3 from statictext within w_pt911_aprueba_partida_prsp
end type
type st_2 from statictext within w_pt911_aprueba_partida_prsp
end type
type st_1 from statictext within w_pt911_aprueba_partida_prsp
end type
type pb_2 from picturebutton within w_pt911_aprueba_partida_prsp
end type
type pb_1 from picturebutton within w_pt911_aprueba_partida_prsp
end type
end forward

global type w_pt911_aprueba_partida_prsp from w_abc
integer width = 1673
integer height = 1324
string title = "[PT911] Aprobacion de partida presupuestal"
string menuname = "m_master"
boolean toolbarvisible = false
st_9 st_9
st_cencos st_cencos
st_5 st_5
st_4 st_4
em_cnta_prsp em_cnta_prsp
em_cencos em_cencos
st_7 st_7
cbx_rev cbx_rev
em_ano em_ano
st_6 st_6
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt911_aprueba_partida_prsp w_pt911_aprueba_partida_prsp

on w_pt911_aprueba_partida_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.st_9=create st_9
this.st_cencos=create st_cencos
this.st_5=create st_5
this.st_4=create st_4
this.em_cnta_prsp=create em_cnta_prsp
this.em_cencos=create em_cencos
this.st_7=create st_7
this.cbx_rev=create cbx_rev
this.em_ano=create em_ano
this.st_6=create st_6
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_9
this.Control[iCurrent+2]=this.st_cencos
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_cnta_prsp
this.Control[iCurrent+6]=this.em_cencos
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.cbx_rev
this.Control[iCurrent+9]=this.em_ano
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.pb_2
this.Control[iCurrent+15]=this.pb_1
end on

on w_pt911_aprueba_partida_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_9)
destroy(this.st_cencos)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.em_cnta_prsp)
destroy(this.em_cencos)
destroy(this.st_7)
destroy(this.cbx_rev)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar( this)

ii_pregunta_delete = 1
end event

type st_9 from statictext within w_pt911_aprueba_partida_prsp
integer x = 823
integer y = 716
integer width = 777
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_cencos from statictext within w_pt911_aprueba_partida_prsp
integer x = 823
integer y = 588
integer width = 777
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_5 from statictext within w_pt911_aprueba_partida_prsp
integer x = 59
integer y = 732
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Prsp:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pt911_aprueba_partida_prsp
integer x = 59
integer y = 604
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cen. Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cnta_prsp from editmask within w_pt911_aprueba_partida_prsp
event ue_dobleclick pbm_lbuttondblclk
integer x = 471
integer y = 716
integer width = 343
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cencos
integer	li_year

li_year = Integer(em_ano.text)

if IsNull(li_year) or li_year <= 0 then
	MessageBox('Aviso', 'Año inválido')
	return
end if

ls_cencos = trim(em_cencos.Text)

if IsNull(ls_cencos) or ls_Cencos = '' then
	MessageBox('Aviso', 'Centro de Costo inválido')
	return
end if

ls_sql = "SELECT a.cnta_prsp AS codigo_cnta_prsp, " &
		  + "a.DESCRIPCION AS DESCRIPCION_cnta_prsp " &
		  + "FROM presupuesto_cuenta a, " &
		  + "presupuesto_partida b " &
		  + "WHERE a.cnta_prsp = b.cnta_prsp " &
		  + "AND b.FLAG_ESTADO <> '0' " &
		  + "AND b.cencos = '" + ls_cencos + "' " &
		  + "AND b.ano = " + string(li_year)
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
	st_9.text = ls_data
end if
end event

type em_cencos from editmask within w_pt911_aprueba_partida_prsp
event ue_dobleclick pbm_lbuttondblclk
integer x = 471
integer y = 588
integer width = 343
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
Integer li_year

li_year = Integer(em_ano.text)

if IsNull(li_year) or li_year <= 0 then
	MessageBox('Aviso', 'Año inválido')
	return
end if

ls_sql = "SELECT distinct a.cencos AS codigo_cencos, " &
		  + "a.DESC_cencos AS DESCRIPCION_cencos " &
		  + "FROM centros_costo a, " &
		  + "presupuesto_partida b " &
		  + "WHERE a.cencos = b.cencos " &
		  + "AND a.FLAG_eSTADO = '1' " &
		  + "AND b.FLAG_eSTADO <> '0' " &
		  + "AND b.ano = " + string(li_year)
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
	st_cencos.text = ls_data
end if

end event

type st_7 from statictext within w_pt911_aprueba_partida_prsp
integer x = 46
integer y = 364
integer width = 1554
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Una vez aprobado no podra alterar las partidas."
boolean focusrectangle = false
end type

type cbx_rev from checkbox within w_pt911_aprueba_partida_prsp
integer x = 1061
integer y = 468
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir "
end type

type em_ano from editmask within w_pt911_aprueba_partida_prsp
integer x = 471
integer y = 460
integer width = 343
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_6 from statictext within w_pt911_aprueba_partida_prsp
integer x = 59
integer y = 476
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt911_aprueba_partida_prsp
integer x = 46
integer y = 232
integer width = 1358
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "para el presupuesto del año indicado."
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt911_aprueba_partida_prsp
integer x = 46
integer y = 168
integer width = 1431
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad aprobar las partidas"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt911_aprueba_partida_prsp
integer x = 69
integer y = 16
integer width = 1390
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
string text = "Aprobacion de partidas presupuestales"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt911_aprueba_partida_prsp
integer x = 759
integer y = 852
integer width = 315
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type pb_1 from picturebutton within w_pt911_aprueba_partida_prsp
integer x = 384
integer y = 852
integer width = 315
integer height = 180
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long ll_ano
String ls_mensaje, ls_cencos, ls_cnta_prsp, ls_flag_estado
integer li_year

li_year 	    = Integer(em_ano.text)
ls_cencos 	 = trim(em_cencos.text)
ls_cnta_prsp = trim(em_cnta_prsp.text)

if IsNull(li_year) or li_year <= 0 then
	MessageBox('Aviso', 'Año inválido')
	return
end if

if IsNull(ls_cencos) or ls_Cencos = '' then
	MessageBox('Aviso', 'Centro de Costo inválido')
	return
end if

if IsNull(ls_cnta_prsp) or ls_Cnta_prsp = '' then
	MessageBox('Aviso', 'Cuenta_presupuestal inválido')
	return
end if

// Debe validar si partida esta anulada o no
SELECT flag_estado 
  INTO :ls_flag_estado 
  FROM presupuesto_partida 
 WHERE ano = :li_year 
   AND cencos = :ls_cencos 
   AND cnta_prsp = :ls_cnta_prsp ;
  
// Si esta anulada, no debe permitir realizar este proceso
IF ls_flag_estado = '0' THEN
	MessageBox('Aviso', 'Partida presupuestal esta anulada')
	Return
END IF
if cbx_rev.checked = true then
	update presupuesto_partida
	   set flag_estado = '1',
			 flag_replicacion = '1'	
 	where ano 			= :li_year
	  and cencos 		= :ls_cencos
	  and cnta_prsp 	= :ls_cnta_prsp;
else
	update presupuesto_partida
	   set flag_estado = '2',
			 flag_replicacion = '1'
 	where ano 			= :li_year
	  and cencos 		= :ls_cencos
	  and cnta_prsp 	= :ls_cnta_prsp;
end if

if SQLCA.SQLCode <> 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', ls_mensaje)
	return
end if

COMMIT;
MessageBox('Aviso', 'Proceso realizado satisfactoriamente')
end event

