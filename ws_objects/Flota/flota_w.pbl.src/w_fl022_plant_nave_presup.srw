$PBExportHeader$w_fl022_plant_nave_presup.srw
forward
global type w_fl022_plant_nave_presup from w_abc_mastdet_smpl
end type
type st_master from statictext within w_fl022_plant_nave_presup
end type
type st_detail from statictext within w_fl022_plant_nave_presup
end type
end forward

global type w_fl022_plant_nave_presup from w_abc_mastdet_smpl
integer width = 2299
integer height = 1900
string title = "Asiganción de plantillas preseupuestales por nave (FL022)"
string menuname = "m_mto_smpl_non_ins"
boolean maxbox = false
boolean resizable = false
event ue_menu ( boolean ab_estado )
st_master st_master
st_detail st_detail
end type
global w_fl022_plant_nave_presup w_fl022_plant_nave_presup

type variables
statictext 	ist_1
long			il_st_color
end variables

event ue_menu(boolean ab_estado);this.MenuId.item[1].item[1].item[2].enabled = ab_estado
this.MenuId.item[1].item[1].item[3].enabled = ab_estado
this.MenuId.item[1].item[1].item[4].enabled = ab_estado

this.MenuId.item[1].item[1].item[2].visible = ab_estado
this.MenuId.item[1].item[1].item[3].visible = ab_estado
this.MenuId.item[1].item[1].item[4].visible = ab_estado

this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado

end event

on w_fl022_plant_nave_presup.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_non_ins" then this.MenuID = create m_mto_smpl_non_ins
this.st_master=create st_master
this.st_detail=create st_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_detail
end on

on w_fl022_plant_nave_presup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_detail)
end on

event ue_open_pre;call super::ue_open_pre;ist_1 = st_master
idw_1 = dw_master

il_st_color = ist_1.backColor
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl022_plant_nave_presup
integer x = 0
integer y = 88
integer width = 2245
integer height = 768
string dataobject = "d_nave_relaciona_tbl"
borderstyle borderstyle = StyleLowered!
end type

event dw_master::constructor;call super::constructor;
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = dw_detail
end event

event dw_master::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
end event

event dw_master::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT
idw_det.ScrollToRow(ll_row)
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

parent.event ue_menu(false)
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl022_plant_nave_presup
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 944
integer width = 2245
integer height = 744
string dataobject = "d_plant_nave_presup_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
long		ll_find
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cod_plantilla"
		
		ls_sql = "select cod_fl_plantilla as codigo_plantilla, " &
				 + "descripcion as descr_plantilla " &
				 + "from vw_fl_plant_con_detalle " &
				 + "where cod_fl_plantilla like '" + gs_origen + "FL%'" &
				 + " and to_char(fecha_inicio_vigencia, 'yyyymmdd') <= '" + string(Today(), 'yyyymmdd') + "'" &
				 + " and to_char(fecha_fin_vigencia, 'yyyymmdd') >= '" + string(Today(), 'yyyymmdd') + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			
			this.object.cod_plantilla	[al_row] = ls_codigo
			this.object.desc_plantilla	[al_row] = ls_data
			
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst = dw_master
idw_det = dw_detail
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_detail
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

parent.event ue_menu(true)
end event

event dw_detail::ue_insert;string 	ls_cod_plant
long 		ll_row
integer 	li_mes, li_anho
date 		ld_today

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

ld_today = Today()

select max(cod_fl_plantilla) 
	into :ls_cod_plant 
from fl_plant_presup 
where Trunc(fecha_fin_vigencia) >= :ld_today 
  and Trunc(fecha_inicio_vigencia) <= :ld_today;

if IsNull(ls_cod_plant) then
	messagebox ('Aviso','No hay plantillas disponibles, deberá crear una plantilla nueva, o activar una existente')
	return -1
end if
	
ll_row = THIS.InsertRow(0)				// insertar registro maestro
ib_insert_mode = True
IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_detail::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;Long 		ll_row_mas
integer 	li_mes, li_ano
string 	ls_cod_plant, ls_nave
Date		ld_fecha

select max(cod_fl_plantilla) 
	into :ls_cod_plant 
from fl_plant_presup 
where Trunc(fecha_fin_vigencia) >= :ld_fecha
  and Trunc(fecha_inicio_vigencia) <= :ld_fecha;

ll_row_mas = dw_master.il_row
if ll_row_mas = 0 then return

ls_nave = dw_master.object.nave[ll_row_mas]
ld_fecha	= Today()

if al_row = 1 then
	li_mes = 1
	li_ano = year(today())+1
end if
	
this.object.cod_plantilla	[al_row] = ls_cod_plant
this.object.nave				[al_row] = ls_nave
this.object.mes				[al_row] = 1
this.object.cod_usr			[al_row] = gs_user
this.object.fecha_registro	[al_row] = ld_fecha
this.object.ano				[al_row] = li_ano

end event

event dw_detail::itemchanged;call super::itemchanged;integer 	li_ano, li_find
string	ls_cod_plant, ls_data
Date		ld_fecha

ld_fecha = Today()
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "ano"
		
		li_ano = Integer(this.object.ano[row])
		li_find = this.find("ano = " + string(li_ano), 1, this.RowCount() )
		
		if li_find > 0 and li_find <> row then
			Messagebox('Aviso', "LA NAVE SOLO PUEDE TENER UNA PLANTILLA DE RATIOS POR AÑO", StopSign!)
			SetNull(li_ano)
			this.object.ano[row] = li_ano
			this.SetColumn("ano")
			return 1
		end if
	
	case "cod_plantilla"
		
		ls_cod_plant = this.object.cod_plantilla[row]
		
		SetNull(ls_data)
		
		select descripcion as descr_plantilla 
			into :ls_data
		from vw_fl_plant_con_detalle 
		where cod_fl_plantilla = :ls_cod_plant
			and trunc(fecha_inicio_vigencia) <= :ld_fecha
			and trunc(fecha_fin_vigencia) 	>= :ld_fecha;
				 
		if IsNull(ls_data) or ls_data = "" then
			MessageBox('Aviso','Código de Plantilla no existe, no esta vigente o no tiene detalle, por favor verifique', StopSign!)
			SetNull(ls_cod_plant)
			this.object.cod_plantilla	[row] = ls_cod_plant
			this.object.desc_plantilla	[row] = ls_cod_plant
			this.SetColumn("cod_plantilla")
			return 1
		end if
		
		this.object.desc_plantilla	[row] = ls_data

end choose

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type st_master from statictext within w_fl022_plant_nave_presup
integer y = 4
integer width = 2245
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Naves Propias o Arrendadas"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_fl022_plant_nave_presup
integer y = 860
integer width = 2245
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Plantillas Asignadas a una nave"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

