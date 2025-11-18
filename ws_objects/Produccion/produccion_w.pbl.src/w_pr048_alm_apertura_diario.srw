$PBExportHeader$w_pr048_alm_apertura_diario.srw
forward
global type w_pr048_alm_apertura_diario from w_abc_master_smpl
end type
type cb_consultar from commandbutton within w_pr048_alm_apertura_diario
end type
type st_1 from statictext within w_pr048_alm_apertura_diario
end type
type em_ano from editmask within w_pr048_alm_apertura_diario
end type
type st_2 from statictext within w_pr048_alm_apertura_diario
end type
type em_mes from editmask within w_pr048_alm_apertura_diario
end type
end forward

global type w_pr048_alm_apertura_diario from w_abc_master_smpl
integer width = 3141
integer height = 1928
string title = "[PR048] Almacen apertura diaria"
string menuname = "m_prod_mant"
cb_consultar cb_consultar
st_1 st_1
em_ano em_ano
st_2 st_2
em_mes em_mes
end type
global w_pr048_alm_apertura_diario w_pr048_alm_apertura_diario

on w_pr048_alm_apertura_diario.create
int iCurrent
call super::create
if this.MenuName = "m_prod_mant" then this.MenuID = create m_prod_mant
this.cb_consultar=create cb_consultar
this.st_1=create st_1
this.em_ano=create em_ano
this.st_2=create st_2
this.em_mes=create em_mes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_consultar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_mes
end on

on w_pr048_alm_apertura_diario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_consultar)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.em_mes)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha

ii_lec_mst = 0

ld_fecha = Date(gnvo_App.of_fecha_Actual())

idw_1     = dw_master

//idw_query = dw_master
dw_master.SetTransObject(SQLCA)

em_ano.Text = string(ld_fecha, 'yyyy')
em_mes.Text = string(ld_fecha, 'mm')
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

//--VERIFICACION Y ASIGNACION DE TIPO DE MAQUINA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr048_alm_apertura_diario
integer y = 132
integer width = 3063
integer height = 1308
string dataobject = "d_abc_alm_apertura_diario_tbl"
end type

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'almacen'
		
		// Verifica que codigo ingresado exista			
		Select desc_almacen
	     into :ls_desc
		  from almacen
		 Where almacen = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe almacen " + data + " o no se encuentra activo, por favor verifique")
			this.object.almacen			[row] = gnvo_app.is_null
			this.object.desc_almacen	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_almacen		[row] = ls_desc

END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 		[al_row] = '1'
this.object.flag_tipo_proceso [al_row] = '1'
this.object.cod_usr 				[al_row] = gs_user
this.object.fecha 				[al_row] = Date(gnvo_app.of_fecha_Actual())
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "almacen"

		ls_sql = "select al.almacen as almacen, " &
				 + "       al.desc_almacen as descripcion_almacen " &
				 + "from almacen al " &
				 + "where al.flag_estado = '1'"
				 
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

type cb_consultar from commandbutton within w_pr048_alm_apertura_diario
integer x = 1106
integer y = 12
integer width = 343
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Consultar"
end type

event clicked;integer li_ano, li_mes

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

dw_master.retrieve( li_ano, li_mes )

dw_master.ii_protect = 0
dw_master.of_protect()
end event

type st_1 from statictext within w_pr048_alm_apertura_diario
integer x = 69
integer y = 16
integer width = 165
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_pr048_alm_apertura_diario
integer x = 229
integer y = 16
integer width = 297
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

type st_2 from statictext within w_pr048_alm_apertura_diario
integer x = 544
integer y = 16
integer width = 165
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes from editmask within w_pr048_alm_apertura_diario
integer x = 713
integer y = 16
integer width = 261
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

