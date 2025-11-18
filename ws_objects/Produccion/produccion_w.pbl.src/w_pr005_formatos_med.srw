$PBExportHeader$w_pr005_formatos_med.srw
forward
global type w_pr005_formatos_med from w_abc_mastdet_smpl
end type
type st_master from statictext within w_pr005_formatos_med
end type
type st_detail from statictext within w_pr005_formatos_med
end type
type st_1 from statictext within w_pr005_formatos_med
end type
end forward

global type w_pr005_formatos_med from w_abc_mastdet_smpl
integer width = 3630
integer height = 1780
string title = "Formatos de Medición (PR005) "
string menuname = "m_mantto_smpl"
st_master st_master
st_detail st_detail
st_1 st_1
end type
global w_pr005_formatos_med w_pr005_formatos_med

type variables
statictext	ist_1
long			il_st_color
end variables

on w_pr005_formatos_med.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_master=create st_master
this.st_detail=create st_detail
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_detail
this.Control[iCurrent+3]=this.st_1
end on

on w_pr005_formatos_med.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_detail)
destroy(this.st_1)
end on

event resize;call super::resize;st_master.X = dw_master.X
st_master.width = dw_master.width

st_detail.X = dw_detail.X
st_detail.width = dw_detail.width

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 1   //hace que no se haga el retrieve del dw_master

il_st_color = st_master.backcolor
ist_1 = st_master

dw_master.ii_protect = 0
dw_master.of_protect()
dw_detail.ii_protect = 0
dw_detail.of_protect()

ib_update_check = TRUE
end event

event ue_query_retrieve;this.event ue_update()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr005_formatos_med
event ue_display ( string as_columna,  long al_row )
integer y = 68
integer width = 3493
integer height = 788
string dataobject = "d_pr_formato_de_medicion_ff"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  			dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;long ll_x
string ls_formato

select trim(:gs_origen) || lpad(to_char(to_number(nvl(max(substr(fma.formato, 3,6)), '0')) + 1) , 6, '0')
	into :ls_formato
	from tg_fmt_med_act fma 
	where substr(fma.formato, 1, 2) = trim(:gs_origen);

this.object.formato[al_row] = ls_formato
this.object.flag_estado[al_row] 	= '1'

parent.event ue_update( )
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_return1, ls_return2, ls_sql

if dw_master.ii_protect = 1 then return

ls_col = trim(lower(string(dwo.name)))

choose case ls_col
		
	case 'cod_labor'
		
		ls_sql = "select cod_labor as Codigo, desc_labor as Descripción from labor where flag_estado = '1'"
				 
		f_lista(ls_sql, ls_return1, ls_return2, '1')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.cod_labor	[row] 	= ls_return1
		this.object.desc_labor	[row] 	= ls_return2
		
		this.ii_update = 1

end choose

end event

event dw_master::getfocus;call super::getfocus;//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
//
//ist_1.backcolor  = il_st_color
//ist_1.italic     = false
//ist_1 = st_master
//ist_1.backcolor = rgb(100,0,0)
//ist_1.italic = true
//
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_return1, ls_return2, ls_sql

this.accepttext( )


choose case ls_col
	case 'cod_labor'
		
		select cod_labor, desc_labor
		   into :ls_return1, :ls_return2
			from labor 
			where flag_estado = '1'
				and trim(cod_labor) = trim(:data);
				 
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'No existe la labor')
			setnull(ls_return1)
			setnull(ls_return1)
		end if
		
		this.object.cod_labor[row] = ls_return1
		this.object.desc_labor[row] = ls_return2
		
		return 2
end choose

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;string ls_formato
parent.event ue_update( )
if currentrow < 1 then return
ls_formato = this.object.formato[currentrow]
dw_detail.retrieve(ls_formato)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr005_formatos_med
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 1060
integer width = 3493
integer height = 476
string dataobject = "d_fmt_med_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_detail
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2, ls_return3

if this.ii_protect = 1 then return

this.AcceptText()

if row < 1 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
		
	case 'atributo'
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion, desc_unidad as medida from vw_tg_atrib_und"
		
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.atributo[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		this.object.desc_unidad[row] = ls_return3
		
		this.ii_update = 1

	case 'cod_maquina'
		
		ls_sql = "select cod_maquina as codigo, desc_maq as descripcion from maquina where flag_estado = '1'"
		
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		
		this.ii_update = 1
		
end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;string ls_tmp
if al_row > 0 then
	if al_row > 1 then
		ls_tmp = this.object.cod_maquina[al_row - 1]
		this.object.cod_maquina[al_row] = ls_tmp

		ls_tmp = this.object.desc_maq[al_row - 1]
		this.object.desc_maq[al_row] = ls_tmp
	end if
	this.object.medicion_min[al_row] = 0.00
	this.object.medicion_max[al_row] = 0.00
end if


end event

event dw_detail::itemchanged;call super::itemchanged;string ls_col, ls_return1, ls_return2, ls_return3
this.AcceptText()

if row < 1 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
		
	case 'atributo'
		
		select atrib_cod, atrib_desc, desc_unidad
			into :ls_return1, :ls_return2, :ls_return3
			from vw_tg_atrib_und
			where trim(atrib_cod) = trim(:data);
		
		if sqlca.sqlcode <> 0 then
			MessageBox(parent.title, 'No existe el atributo de medición ~rpara el código ingresado')
			setnull(ls_return1)
			setnull(ls_return2)
			setnull(ls_return3)
		end if
		
		this.object.atributo[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		this.object.desc_unidad[row] = ls_return3
		
		return 2

	case 'cod_maquina'
		
		select cod_maquina, desc_maq
			into :ls_return1, :ls_return2
		from maquina
		where trim(cod_maquina) = trim(:data)
		  and flag_estado = '1';
		
		if sqlca.sqlcode <> 0 then
		MessageBox(parent.title, 'No existe máquina para ~rel código ingresado')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		
		return 2
		
end choose
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type st_master from statictext within w_pr005_formatos_med
integer x = 5
integer width = 3493
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Formatos de Medición - Cabecera"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_pr005_formatos_med
integer x = 5
integer y = 876
integer width = 3493
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Formatos de Medición - Detalle"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr005_formatos_med
integer x = 5
integer y = 952
integer width = 3493
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Las labores que pueda seleccionar deberán haber sido ingresadas previamente en el módulo de Operaciones_OT"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

