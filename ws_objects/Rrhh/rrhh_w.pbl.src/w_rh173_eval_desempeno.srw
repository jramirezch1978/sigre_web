$PBExportHeader$w_rh173_eval_desempeno.srw
forward
global type w_rh173_eval_desempeno from w_abc_master_smpl
end type
type cb_genera from commandbutton within w_rh173_eval_desempeno
end type
type st_2 from statictext within w_rh173_eval_desempeno
end type
type st_1 from statictext within w_rh173_eval_desempeno
end type
type em_mes from editmask within w_rh173_eval_desempeno
end type
type em_ano from editmask within w_rh173_eval_desempeno
end type
type cb_1 from commandbutton within w_rh173_eval_desempeno
end type
type gb_2 from groupbox within w_rh173_eval_desempeno
end type
end forward

global type w_rh173_eval_desempeno from w_abc_master_smpl
integer width = 2459
integer height = 1576
string title = "(RH173) Evaluación de Desempeño del Trabajador"
string menuname = "m_master_cerrar"
boolean maxbox = false
boolean resizable = false
cb_genera cb_genera
st_2 st_2
st_1 st_1
em_mes em_mes
em_ano em_ano
cb_1 cb_1
gb_2 gb_2
end type
global w_rh173_eval_desempeno w_rh173_eval_desempeno

type variables

end variables

on w_rh173_eval_desempeno.create
int iCurrent
call super::create
if this.MenuName = "m_master_cerrar" then this.MenuID = create m_master_cerrar
this.cb_genera=create cb_genera
this.st_2=create st_2
this.st_1=create st_1
this.em_mes=create em_mes
this.em_ano=create em_ano
this.cb_1=create cb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_genera
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_mes
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_rh173_eval_desempeno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_genera)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)
end event

event ue_update_pre;integer li_row, li_calif_valor, li_count_registro, li_row_det

li_row = dw_master.GetRow()

IF li_row > 0 THEN

  li_calif_valor = dw_master.GetItemNumber(li_row,'calif_valor')

  li_count_registro = dw_master.RowCount()
  IF li_count_registro > 0 THEN
	  FOR li_row_det = 1 TO li_count_registro
			IF isnull(dw_master.object.calif_valor[li_row_det]) THEN
				MessageBox('Aviso','Falta Calificar al Trabajador')
				RETURN
			END IF
	  NEXT
  END IF
  
END IF

dw_master.of_set_flag_replicacion( )
end event

event resize;// Override
end event

event ue_dw_share;// Override
end event

event ue_modify;call super::ue_modify;//integer li_ano, li_mes, li_verifica, li_protect
//string  ls_codigo
//
//li_ano    = integer(em_ano.text)
//li_mes    = integer(em_mes.text)
//ls_codigo = string(em_codigo.text)
//
//select count(*)
//  into :li_verifica
//  from rrhh_eval_trab_desempeno
//  where ano = :li_ano and mes = :li_mes and cod_trabajador = :ls_codigo and
//  		  flag_estado = '1' ;
//  		  
//if li_verifica > 0 then
//	
//	li_protect = integer(dw_master.Object.calif_valor.Protect)
//	if li_protect = 0 then
//		dw_master.Object.calif_valor.Protect = 1
//	end if 
//	  
//end if
//
//
end event

event open;call super::open;Integer li_ano, li_mes
//Año y Mes x Defecto
li_ano = Integer(String(today(),'yyyy'))
li_mes = Integer(String(today(),'mm'))

if li_mes = 12 then
	li_mes = 1
	li_ano = li_ano - 1
else 
	li_mes = li_mes - 1
end if

em_ano.text = String(li_ano)
em_mes.text = String(li_mes)
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh173_eval_desempeno
integer x = 87
integer y = 328
integer width = 2258
integer height = 1016
integer taborder = 50
string dataobject = "d_av_eval_trabajador"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::clicked;call super::clicked;Long    ll_row_master
String  ls_calif_concepto, ls_protect, ls_flag_estado

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]

if ls_flag_estado = '1' then return

ls_calif_concepto = dw_master.Object.calif_concepto [ll_row_master]

if ls_calif_concepto = 'ASICAP' then
	ls_protect=dw_master.Describe("calif_valor.protect")
	if ls_protect = '0' then
	   dw_master.of_column_protect('calif_valor')
	end if
else
	ls_protect=dw_master.Describe("calif_valor.protect")
	if ls_protect = '1' then
	   dw_master.of_column_protect('calif_valor')
	end if
end if

end event

event dw_master::buttonclicked;call super::buttonclicked;openwithparm(w_rsp_popup,string(row))
dw_master.ii_update = 1
end event

event dw_master::doubleclicked;call super::doubleclicked;if row <= 0 then return
str_parametros lstr_rep
				
integer li_ano, li_mes, li_verifica
string  ls_cod_area, ls_seccion, ls_codigo, ls_condes, ls_ap_pat, ls_ap_mat, ls_nombres

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

if isnull(li_ano) or li_ano = 0 then
	MessageBox('Aviso','Debe Ingresar Año de Proceso')
	return
end if

if isnull(li_mes) or li_mes = 0 then
	MessageBox('Aviso','Debe Ingresar Mes de Proceso')
	return
end if

ls_codigo = GetItemString(row,"cod_trabajador")
ls_ap_pat = GetItemString(row,"apel_paterno")
ls_ap_mat = GetItemString(row,"apel_materno")
ls_nombres = GetItemString(row,"nombres")

If IsNull(ls_ap_pat) or Len(Trim(ls_ap_pat)) = 0 then
	ls_ap_pat =''
end if

If IsNull(ls_ap_mat) or Len(Trim(ls_ap_mat)) = 0 then
	ls_ap_mat =''
end if

If IsNull(ls_nombres) or Len(Trim(ls_nombres)) = 0 then
	ls_nombres =''
end if

select condes 
  into :ls_condes
  from maestro m
  where cod_trabajador = :ls_codigo ;
if isnull(ls_condes) then
	MessageBox('Aviso','Tipo de Evaluación por Actitudes NO Existe, Ingrese en el Maestro de Personal')
	return
end if
  
lstr_rep.long1 	= li_ano
lstr_rep.long2 	= li_mes
lstr_rep.string1 	= ls_codigo
lstr_rep.string2 	= ls_condes
lstr_rep.string3 = ls_ap_pat +' '+ ls_ap_mat +' '+ ls_nombres
	
OpenWithParm (w_rh173_eval_desempeno_rsp, lstr_rep)
				
end event

type cb_genera from commandbutton within w_rh173_eval_desempeno
integer x = 1339
integer y = 132
integer width = 311
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.SetMicroHelp('Realizando Evaluación por Desempeño')

integer li_ano, li_mes, li_verifica
string  ls_cod_area, ls_seccion, ls_codigo, ls_condes

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

if isnull(li_ano) or li_ano = 0 then
	MessageBox('Aviso','Debe Ingresar Año de Proceso')
	return
end if

if isnull(li_mes) or li_mes = 0 then
	MessageBox('Aviso','Debe Ingresar Mes de Proceso')
	return
end if
SetPointer(HourGlass!)
dw_master.retrieve(li_ano, li_mes, gs_user)
SetPointer(Arrow!)


end event

type st_2 from statictext within w_rh173_eval_desempeno
integer x = 896
integer y = 140
integer width = 105
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh173_eval_desempeno
integer x = 466
integer y = 140
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type em_mes from editmask within w_rh173_eval_desempeno
integer x = 1019
integer y = 136
integer width = 174
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_ano from editmask within w_rh173_eval_desempeno
integer x = 599
integer y = 136
integer width = 261
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_rh173_eval_desempeno
integer x = 1710
integer y = 132
integer width = 311
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aprobar"
end type

event clicked;Integer li_tot, li_i, li_ano, li_mes
String ls_status, ls_codigo
li_tot = dw_master.RowCount()
li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

if isnull(li_ano) or li_ano = 0 then
	MessageBox('Aviso','Debe Ingresar Año de Proceso')
	return
end if

if isnull(li_mes) or li_mes = 0 then
	MessageBox('Aviso','Debe Ingresar Mes de Proceso')
	return
end if

For li_i = 1 to li_tot
	ls_status = dw_master.GetItemString(li_i,"status")
	ls_codigo = dw_master.GetItemString(li_i,"cod_trabajador")
	
	//Status = 2 Evaluado pero no aprobado
	If ls_status = "2" then
		Update rrhh_eval_trab_desempeno
			set flag_estado = '1'
		 where ano = :li_ano
		   and mes = :li_mes
		   and cod_trabajador = :ls_codigo;

		if sqlca.sqlcode = -1 then
			Messagebox("Aviso",string(sqlca.sqlcode)+ " " + &
						string(sqlca.sqlerrtext), StopSign!)
			RollBack ;
			Return
		end if
	end if
Next
Commit;
cb_genera.TriggerEvent(Clicked!)		
end event

type gb_2 from groupbox within w_rh173_eval_desempeno
integer x = 407
integer y = 60
integer width = 855
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Evaluación "
end type

