$PBExportHeader$w_rh483_p_backup_grupos_calculo.srw
forward
global type w_rh483_p_backup_grupos_calculo from w_prc
end type
type cb_1 from commandbutton within w_rh483_p_backup_grupos_calculo
end type
type em_ano from editmask within w_rh483_p_backup_grupos_calculo
end type
type em_mes from editmask within w_rh483_p_backup_grupos_calculo
end type
type em_semana from editmask within w_rh483_p_backup_grupos_calculo
end type
type st_1 from statictext within w_rh483_p_backup_grupos_calculo
end type
type st_2 from statictext within w_rh483_p_backup_grupos_calculo
end type
type st_3 from statictext within w_rh483_p_backup_grupos_calculo
end type
type gb_1 from groupbox within w_rh483_p_backup_grupos_calculo
end type
end forward

global type w_rh483_p_backup_grupos_calculo from w_prc
integer width = 1847
integer height = 748
string title = "(RH483) Backup de Grupos de Cálculos"
cb_1 cb_1
em_ano em_ano
em_mes em_mes
em_semana em_semana
st_1 st_1
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_rh483_p_backup_grupos_calculo w_rh483_p_backup_grupos_calculo

on w_rh483_p_backup_grupos_calculo.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.em_semana=create em_semana
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.em_semana
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh483_p_backup_grupos_calculo.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.em_semana)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type cb_1 from commandbutton within w_rh483_p_backup_grupos_calculo
integer x = 763
integer y = 488
integer width = 293
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Proceso del BACKUP de grupos de cálculos ')

string  ls_mensaje
integer li_ano, li_mes, li_semana

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)
li_semana = integer(em_semana.text)

DECLARE pb_usp_rh_backup_grupos_calculo PROCEDURE FOR USP_RH_BACKUP_GRUPOS_CALCULO
        ( :li_ano, :li_mes, :li_semana ) ;
EXECUTE pb_usp_rh_backup_grupos_calculo ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de backup de grupos de cálculo falló', Exclamation! )
  Parent.SetMicroHelp('Proceso no se llegó a realizar')
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type em_ano from editmask within w_rh483_p_backup_grupos_calculo
integer x = 434
integer y = 212
integer width = 242
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_rh483_p_backup_grupos_calculo
integer x = 878
integer y = 212
integer width = 169
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_semana from editmask within w_rh483_p_backup_grupos_calculo
integer x = 1353
integer y = 212
integer width = 169
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_1 from statictext within w_rh483_p_backup_grupos_calculo
integer x = 279
integer y = 220
integer width = 114
integer height = 56
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

type st_2 from statictext within w_rh483_p_backup_grupos_calculo
integer x = 713
integer y = 220
integer width = 114
integer height = 56
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

type st_3 from statictext within w_rh483_p_backup_grupos_calculo
integer x = 1106
integer y = 220
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh483_p_backup_grupos_calculo
integer x = 183
integer y = 116
integer width = 1458
integer height = 244
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

