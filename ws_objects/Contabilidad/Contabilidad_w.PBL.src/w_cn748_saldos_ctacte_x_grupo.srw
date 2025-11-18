$PBExportHeader$w_cn748_saldos_ctacte_x_grupo.srw
forward
global type w_cn748_saldos_ctacte_x_grupo from w_report_smpl
end type
type sle_grupo from singlelineedit within w_cn748_saldos_ctacte_x_grupo
end type
type sle_descripcion from singlelineedit within w_cn748_saldos_ctacte_x_grupo
end type
type pb_1 from picturebutton within w_cn748_saldos_ctacte_x_grupo
end type
type sle_ano from singlelineedit within w_cn748_saldos_ctacte_x_grupo
end type
type sle_mes from singlelineedit within w_cn748_saldos_ctacte_x_grupo
end type
type cb_1 from commandbutton within w_cn748_saldos_ctacte_x_grupo
end type
type st_1 from statictext within w_cn748_saldos_ctacte_x_grupo
end type
type st_2 from statictext within w_cn748_saldos_ctacte_x_grupo
end type
type st_3 from statictext within w_cn748_saldos_ctacte_x_grupo
end type
type dw_origen from datawindow within w_cn748_saldos_ctacte_x_grupo
end type
type st_4 from statictext within w_cn748_saldos_ctacte_x_grupo
end type
type gb_1 from groupbox within w_cn748_saldos_ctacte_x_grupo
end type
end forward

global type w_cn748_saldos_ctacte_x_grupo from w_report_smpl
integer width = 3611
integer height = 1732
string title = "Saldos de cuenta corriente x grupo de codigos (CN748)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_grupo sle_grupo
sle_descripcion sle_descripcion
pb_1 pb_1
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_1 st_1
st_2 st_2
st_3 st_3
dw_origen dw_origen
st_4 st_4
gb_1 gb_1
end type
global w_cn748_saldos_ctacte_x_grupo w_cn748_saldos_ctacte_x_grupo

on w_cn748_saldos_ctacte_x_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_grupo=create sle_grupo
this.sle_descripcion=create sle_descripcion
this.pb_1=create pb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.dw_origen=create dw_origen
this.st_4=create st_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_grupo
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.sle_mes
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.dw_origen
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.gb_1
end on

on w_cn748_saldos_ctacte_x_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_grupo)
destroy(this.sle_descripcion)
destroy(this.pb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_origen)
destroy(this.st_4)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_origen,ls_orig
ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)
ls_origen = dw_origen.object.origen[1]
If len(trim(ls_origen))= 0 or IsNull(ls_origen) then
	ls_origen ='%'
	ls_orig = 'Todos los Origenes'
else
	ls_orig = ls_origen
	ls_origen = trim(ls_origen)+'%'
end if
DECLARE PB_USP_CNT_RPT_SALDOS_CTACTE_CR PROCEDURE FOR USP_CNT_RPT_SALDOS_CTACTE
        (:ls_ano, :ls_mes, :ls_origen) ;
Execute PB_USP_CNT_RPT_SALDOS_CTACTE_CR ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_origen.text = ls_orig

end event

type dw_report from w_report_smpl`dw_report within w_cn748_saldos_ctacte_x_grupo
integer x = 32
integer y = 288
integer width = 3090
integer height = 1244
string dataobject = "d_cntbl_rpt_saldos_ctacte_cr_tbl"
end type

type sle_grupo from singlelineedit within w_cn748_saldos_ctacte_x_grupo
integer x = 270
integer y = 96
integer width = 283
integer height = 88
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

event modified;Long ll_count
String ls_grupo, ls_descripcion

ls_grupo = sle_grupo.text

SELECT count(*) into :ll_count
FROM cod_rel_grupo
WHERE grupo = :ls_grupo ;

IF ll_count = 0 THEN
	MessageBox('Aviso','Grupo no definido')
	sle_grupo.text = ''
	sle_descripcion.text = ''
ELSE
	SELECT descripcion into :ls_descripcion
	FROM cod_rel_grupo
	WHERE grupo = :ls_grupo ;
	
	sle_descripcion.text = ls_descripcion
END IF

end event

type sle_descripcion from singlelineedit within w_cn748_saldos_ctacte_x_grupo
integer x = 699
integer y = 96
integer width = 1239
integer height = 88
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

type pb_1 from picturebutton within w_cn748_saldos_ctacte_x_grupo
integer x = 562
integer y = 88
integer width = 128
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT COD_REL_GRUPO.GRUPO AS GRUPO, '&
										 +'COD_REL_GRUPO.DESCRIPCION AS DESCRIPCION '&
										 +'FROM COD_REL_GRUPO ' 
					
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_grupo.text = lstr_seleccionar.param1[1]
		sle_descripcion.text = lstr_seleccionar.param2[1]
	END IF

end event

type sle_ano from singlelineedit within w_cn748_saldos_ctacte_x_grupo
integer x = 2094
integer y = 104
integer width = 155
integer height = 88
integer taborder = 30
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

type sle_mes from singlelineedit within w_cn748_saldos_ctacte_x_grupo
integer x = 2432
integer y = 104
integer width = 123
integer height = 88
integer taborder = 40
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

type cb_1 from commandbutton within w_cn748_saldos_ctacte_x_grupo
integer x = 3205
integer y = 92
integer width = 288
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;string  ls_grupo, ls_ano, ls_mes
Long ll_count

ls_grupo = sle_grupo.text

select count(*) into :ll_count from cod_rel_agrupamiento where grupo=:ls_grupo ;

IF ll_count=0 THEN
	MessageBox('Aviso', 'Grupo no definido')
	return
END IF ;

delete from tt_cntbl_cliente ;

insert into tt_cntbl_cliente 
( select cr.cod_relacion, p.nom_proveedor
  from cod_rel_agrupamiento cr, proveedor p 
  where cr.cod_relacion = p.proveedor and
  cr.grupo = :ls_grupo ) ;

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type st_1 from statictext within w_cn748_saldos_ctacte_x_grupo
integer x = 78
integer y = 112
integer width = 187
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grupo:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn748_saldos_ctacte_x_grupo
integer x = 1952
integer y = 120
integer width = 133
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn748_saldos_ctacte_x_grupo
integer x = 2295
integer y = 120
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type dw_origen from datawindow within w_cn748_saldos_ctacte_x_grupo
integer x = 2825
integer y = 108
integer width = 256
integer height = 80
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_origent_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;SetTransObject(sqlca)
InsertRow(0)
end event

type st_4 from statictext within w_cn748_saldos_ctacte_x_grupo
integer x = 2610
integer y = 120
integer width = 206
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn748_saldos_ctacte_x_grupo
integer x = 32
integer y = 20
integer width = 3090
integer height = 224
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

