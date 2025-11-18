$PBExportHeader$w_ope319_cierra_amp.srw
forward
global type w_ope319_cierra_amp from w_abc_master
end type
type st_1 from statictext within w_ope319_cierra_amp
end type
type sle_origen from singlelineedit within w_ope319_cierra_amp
end type
type sle_nro_mov from singlelineedit within w_ope319_cierra_amp
end type
type st_2 from statictext within w_ope319_cierra_amp
end type
type cb_1 from commandbutton within w_ope319_cierra_amp
end type
type cb_2 from commandbutton within w_ope319_cierra_amp
end type
end forward

global type w_ope319_cierra_amp from w_abc_master
integer width = 2656
integer height = 732
string title = "[OPE319] Cierre de AMP"
string menuname = "m_abc_master"
st_1 st_1
sle_origen sle_origen
sle_nro_mov sle_nro_mov
st_2 st_2
cb_1 cb_1
cb_2 cb_2
end type
global w_ope319_cierra_amp w_ope319_cierra_amp

on w_ope319_cierra_amp.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
this.st_1=create st_1
this.sle_origen=create sle_origen
this.sle_nro_mov=create sle_nro_mov
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_nro_mov
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
end on

on w_ope319_cierra_amp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_origen)
destroy(this.sle_nro_mov)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
end on

type dw_master from w_abc_master`dw_master within w_ope319_cierra_amp
integer y = 192
integer width = 2555
integer height = 328
string dataobject = "d_abc_cerrar_amp_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
end event

type st_1 from statictext within w_ope319_cierra_amp
integer x = 69
integer y = 72
integer width = 183
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_ope319_cierra_amp
integer x = 293
integer y = 56
integer width = 142
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_nro_mov from singlelineedit within w_ope319_cierra_amp
integer x = 1157
integer y = 56
integer width = 343
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ope319_cierra_amp
integer x = 773
integer y = 72
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. movimiento:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope319_cierra_amp
integer x = 1577
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera"
end type

event clicked;String ls_origen

Long ll_nro_mov, ll_count

ls_origen = TRIM(sle_origen.text)
ll_nro_mov = LONG(TRIM(sle_nro_mov.text))

SELECT count(*) 
  INTO :ll_count 
  FROM articulo_mov_proy amp 
 WHERE amp.cod_origen = :ls_origen AND 
 		 amp.nro_mov = :ll_nro_mov AND 
		 amp.tipo_doc = (select doc_ot from logparam where reckey='1') and 
 		 amp.tipo_mov = (select oper_cons_interno from logparam where reckey='1') ;

IF ll_count > 0 THEN
	dw_master.retrieve(ls_origen, ll_nro_mov)
ELSE
	MessageBox('Aviso', 'AMP no existe')
	Return
END IF




end event

type cb_2 from commandbutton within w_ope319_cierra_amp
integer x = 1970
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesa"
end type

event clicked;String ls_origen, ls_flag_estado

Long ll_nro_mov 

IF dw_master.GetRow() = 0 THEN RETURN 

ls_origen = TRIM(sle_origen.text)
ll_nro_mov = LONG(sle_nro_mov.text)

SELECT flag_estado 
  INTO :ls_flag_estado 
 FROM articulo_mov_proy 
 WHERE cod_origen = :ls_origen AND
 		 nro_mov = :ll_nro_mov ;

// De activo pasa a cerrar		  
IF ls_flag_estado = '1' THEN
	dw_master.object.flag_estado[1]='2'
	messagebox('Aviso','Cierra AMP')
// De cerrado pasa a activo	
ELSEIF ls_flag_estado = '2' THEN
	dw_master.object.flag_estado[1]='1'
	messagebox('Aviso','Abre AMP')
END IF
dw_master.AcceptText()
dw_master.ii_update = 1




end event

