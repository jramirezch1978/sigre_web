$PBExportHeader$w_fl042_dias_motorista.srw
forward
global type w_fl042_dias_motorista from w_abc_master_smpl
end type
type st_1 from statictext within w_fl042_dias_motorista
end type
type em_year from editmask within w_fl042_dias_motorista
end type
type em_mes from editmask within w_fl042_dias_motorista
end type
type cb_retrieve from commandbutton within w_fl042_dias_motorista
end type
end forward

global type w_fl042_dias_motorista from w_abc_master_smpl
integer width = 2176
integer height = 1232
string title = "(FL042) Días para Bonificaciones (Sueldo Fijo)"
string menuname = "m_mto_smpl"
boolean resizable = false
st_1 st_1
em_year em_year
em_mes em_mes
cb_retrieve cb_retrieve
end type
global w_fl042_dias_motorista w_fl042_dias_motorista

forward prototypes
public subroutine of_datos_tripulante (string as_tripulante, long al_row)
end prototypes

public subroutine of_datos_tripulante (string as_tripulante, long al_row);String	ls_cargo_tripulante, ls_desc_cargo, ls_nave, ls_nom_nave

select fl.cargo_tripulante, fc.descr_cargo, fl.nave, tn.nomb_nave
	into :ls_cargo_tripulante, :ls_desc_cargo, :ls_nave, :ls_nom_nave
from 	fl_tripulantes fl,
		fl_cargo_tripulantes fc,
		tg_naves             tn
where fl.cargo_tripulante 	= fc.cargo_tripulante
  and fl.nave             	= tn.nave       
  and fl.tripulante 			= :as_tripulante;

//Datos por defecto
dw_master.object.cargo_tripulante	[al_row] = ls_cargo_tripulante
dw_master.object.descr_cargo			[al_row] = ls_desc_cargo
dw_master.object.nave					[al_row] = ls_nave
dw_master.object.nomb_nave				[al_row] = ls_nom_nave
end subroutine

on w_fl042_dias_motorista.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.st_1=create st_1
this.em_year=create em_year
this.em_mes=create em_mes
this.cb_retrieve=create cb_retrieve
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.cb_retrieve
end on

on w_fl042_dias_motorista.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.cb_retrieve)
end on

event ue_open_pre;call super::ue_open_pre;Integer 	li_count, li_year, li_mes
date		ld_hoy
ii_lec_mst = 0

select count(*)
	into :li_count
from fl_dias_motorista t;

if li_count > 0 then
	select anio, mes
		into :li_year, :li_mes
	from fl_dias_motorista
	order by anio desc, mes desc;
else
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	li_year = year(ld_hoy)
	li_mes  = Month(ld_hoy)
	
end if

em_year.text = String(li_year)
em_mes.text = String(li_mes)

this.event ue_retrieve()


end event

event ue_retrieve;call super::ue_retrieve;Integer li_year, li_mes

li_year 	= Integer(em_year.text)
li_mes	= Integer(em_mes.text)

dw_master.Retrieve(li_year, li_mes)
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl042_dias_motorista
integer y = 112
string dataobject = "d_abc_dias_motorista_tbl"
end type

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
string ls_codigo, ls_data, ls_sql, ls_cargo_tripulante, ls_desc_cargo, ls_nave, ls_nom_nave
choose case lower(as_columna)
		
	case "cod_motorista"

		ls_sql = "SELECT t.cod_trabajador AS CODIGO_trabajador, " &
				  + "t.nom_trabajador AS nombre_trabajador, " &
				  + "t.DNI as documento_identidad " &
				  + "FROM vw_pr_trabajador t, " &
				  + "     fl_tripulantes ft " &
				  + "where t.cod_Trabajador = ft.tripulante " & 
				  + "  and t.flag_estado = '1' " &
				  + "  and ft.flag_estado = '1'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_motorista	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			
			of_datos_tripulante(ls_codigo, al_row)
			
			this.SetColumn('nro_dias')
			
			this.ii_update = 1
		end if

	case "cargo_tripulante"

		ls_sql = "select cargo_tripulante as cargo_tripulante, " &
				 + "descr_cargo as descripcion_cargo " &
				 + "from fl_cargo_tripulantes " &
				 + "where flag_estado = '1'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cargo_tripulante	[al_row] = ls_codigo
			this.object.descr_cargo			[al_row] = ls_data
			
			this.ii_update = 1
		end if

	case "nave"

		ls_sql = "select tn.nave as nave, " &
				 + "tn.nomb_nave as nombre_nave " &
				 + "from tg_naves tn " &
				 + "where tn.flag_tipo_flota = 'P'" &
				 + "  and tn.flag_estado = '1'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nave			[al_row] = ls_codigo
			this.object.nomb_nave	[al_row] = ls_data
			
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_motorista'
		
		// Verifica que codigo ingresado exista			
		Select nom_trabajador
	     into :ls_desc
		  from vw_pr_trabajador
		 Where cod_trabajador = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Trabaajdor o no se encuentra activo, por favor verifique")
			this.object.cod_motorista		[row] = gnvo_app.is_null
			this.object.nom_trabajador		[row] = gnvo_app.is_null
			this.object.cargo_tripulante	[row] = gnvo_app.is_null
			this.object.descr_cargo			[row] = gnvo_app.is_null
			this.object.nave					[row] = gnvo_app.is_null
			this.object.nomb_nave			[row] = gnvo_app.is_null
			
			return 1
			
		end if

		this.object.nom_trabajador			[row] = ls_desc
		
		of_datos_tripulante(data, row)
		
	CASE 'cargo_tripulante'
		
		// Verifica que codigo ingresado exista			
		Select fc.descr_cargo
	     into :ls_desc
		  from fl_cargo_tripulantes fc
		 Where fc.cargo_tripulante = :data  
		   and fc.flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "El cargo ingresado " + data + " No existe o no se encuentra activo, por favor verifique")
			this.object.cargo_tripulante	[row] = gnvo_app.is_null
			this.object.descr_cargo			[row] = gnvo_app.is_null
			
			return 1
			
		end if

		this.object.descr_cargo			[row] = ls_desc
		

	CASE 'nave'
		
		// Verifica que codigo ingresado exista			
		Select nomb_nave
	     into :ls_desc
		  from tg_naves
		 Where nave = :data  
		   and flag_estado = '1'
			and flag_tipo_flota = 'P';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Nave " + data + " No existe, no se encuentra activo o no corresponde a flota propia, por favor verifique")
			this.object.nave					[row] = gnvo_app.is_null
			this.object.nomb_nave			[row] = gnvo_app.is_null
			
			return 1
			
		end if

		this.object.nomb_nave			[row] = ls_desc
		
END CHOOSE
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer 	li_year, li_mes
Date		ld_hoy

ld_hoy = Date(gnvo_app.of_fecha_actual())

if trim(em_year.text) <> '' then
	li_year = Integer(em_year.text)
else
	li_year = year(ld_hoy)
end if

if trim(em_mes.text) <> '' then
	li_mes = Integer(em_mes.text)
else
	li_mes = month(ld_hoy)
end if


this.object.anio 		[al_row] = li_year
this.object.mes 		[al_row] = li_mes
this.object.nro_dias [al_row] = 0

this.SetColumn('cod_motorista')
end event

type st_1 from statictext within w_fl042_dias_motorista
integer y = 8
integer width = 402
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
string text = "Periodo : "
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_fl042_dias_motorista
integer x = 416
integer y = 8
integer width = 343
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type em_mes from editmask within w_fl042_dias_motorista
integer x = 777
integer y = 8
integer width = 215
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#0"
boolean spin = true
double increment = 1
string minmax = "1~~12"
end type

type cb_retrieve from commandbutton within w_fl042_dias_motorista
integer x = 1029
integer y = 8
integer width = 343
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_retrieve()
end event

