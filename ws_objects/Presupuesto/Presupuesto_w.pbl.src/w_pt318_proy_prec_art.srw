$PBExportHeader$w_pt318_proy_prec_art.srw
forward
global type w_pt318_proy_prec_art from w_abc_master_smpl
end type
type st_1 from statictext within w_pt318_proy_prec_art
end type
type em_ano from editmask within w_pt318_proy_prec_art
end type
type cb_aceptar from commandbutton within w_pt318_proy_prec_art
end type
end forward

global type w_pt318_proy_prec_art from w_abc_master_smpl
integer height = 1440
string title = "Precio Proyectado Artículo (PT318)"
string menuname = "m_mantenimiento_simple"
st_1 st_1
em_ano em_ano
cb_aceptar cb_aceptar
end type
global w_pt318_proy_prec_art w_pt318_proy_prec_art

type variables
string is_dolar
end variables

forward prototypes
public subroutine of_retrieve (integer ai_year)
end prototypes

public subroutine of_retrieve (integer ai_year);this.event ue_update_request( )

dw_master.retrieve(ai_year)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect( )
end subroutine

on w_pt318_proy_prec_art.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.st_1=create st_1
this.em_ano=create em_ano
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.cb_aceptar
end on

on w_pt318_proy_prec_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.cb_aceptar)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
ib_log = TRUE

select cod_dolares
  into :is_dolar
  from logparam
 where reckey = '1';

em_ano.text = string(year(date(f_fecha_actual())))
cb_aceptar.event clicked( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_pt318_proy_prec_art
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 156
integer height = 928
string dataobject = "d_abc_prsp_prec_proy_art_grd"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen
Decimal	ldc_ult_compra
str_parametros sl_param
choose case lower(as_columna)
	case "cod_art"
		ls_origen = this.object.cod_origen[al_row]
		
		if ls_origen = '' or IsNull(ls_origen) then
			MessageBox('Aviso', 'Debe indicar la unidad operativa previamente')
			return
		end if
		
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		
		ls_codigo = sl_param.field_ret[1]
		
		select NVL(aa.Costo_ult_compra, 0)
			into :ldc_ult_compra
		from articulo_almacen aa,
			  almacen			 al
		where al.almacen = aa.almacen
		  and al.cod_origen = :ls_origen
		  and aa.cod_art = :ls_codigo;
		
		if ldc_ult_compra <= 0 then
			select USF_CMP_ULT_PREC_COTIZ(:ls_codigo)
			  into :ldc_ult_compra
			  from dual;
		end if

		IF sl_param.titulo <> 'n' then
			this.object.cod_art			[al_row] = sl_param.field_ret[1]
			this.object.desc_art			[al_row] = sl_param.field_ret[2]
			this.object.und				[al_row] = sl_param.field_ret[3]
			if ldc_ult_compra > 0 then
				this.object.precio_proyect	[al_row] = ldc_ult_compra
				this.object.cod_moneda		[al_row] = is_dolar
			end if
			this.ii_update = 1
		END IF

	case "cod_moneda"
		ls_sql = "SELECT COD_MONEDA AS CODIGO_moneda, " &
				  + "descripcion AS DESCRIPCION_moneda " &
				  + "FROM moneda " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr	[al_row] = gs_user
this.object.ano		[al_row] = Integer(em_ano.text)
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_desc, ls_und, ls_null, ls_origen
Decimal	ldc_ult_compra

SetNull(ls_null)
this.AcceptText()
choose case lower(dwo.name)
	case "cod_art"
		ls_origen = this.object.cod_origen[row]
		
		if ls_origen = '' or IsNull(ls_origen) then
			MessageBox('Aviso', 'Debe indicar la unidad operativa previamente')
			return
		end if
		
		Select desc_art, und
			into :ls_desc, :ls_und
		from articulo 
		where cod_art = :data
		  and flag_estado = '1';
	
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Articulo no existe o no esta activo", Exclamation!)		
			this.object.cod_Art			[row] = ls_null
			this.object.desc_art			[row] = ls_null
			this.object.und				[row] = ls_null
			this.object.precio_proyect	[row] = 0
			this.object.cod_moneda		[row] = ls_null
			Return 1
		end if

		select NVL(aa.Costo_ult_compra, 0)
			into :ldc_ult_compra
		from articulo_almacen aa,
			  almacen			 al
		where al.almacen = aa.almacen
		  and al.cod_origen = :ls_origen
		  and aa.cod_art = :data;
		
		if ldc_ult_compra <= 0 then
			select USF_CMP_ULT_PREC_COTIZ(:data)
			  into :ldc_ult_compra
			  from dual;
		end if

		this.object.desc_art			[row] = ls_desc
		this.object.und				[row] = ls_und
		if ldc_ult_compra > 0 then
			this.object.precio_proyect	[row] = ldc_ult_compra
			this.object.cod_moneda		[row] = is_dolar
		end if		
		
	case "cod_moneda"
		Select descripcion
			into :ls_desc
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';
	
		if SQLCA.SQLCode = 100 then
			Messagebox( "Error", "Código de moneda no existe o no esta activo", Exclamation!)		
			this.object.cod_moneda			[row] = ls_null
			Return 1
		end if
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

type st_1 from statictext within w_pt318_proy_prec_art
integer x = 594
integer y = 32
integer width = 439
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
string text = "Ingrese el año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_pt318_proy_prec_art
event ue_keyup pbm_keyup
integer x = 1051
integer y = 20
integer width = 334
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event ue_keyup;integer li_ano

if len(trim(this.text) ) < 4 then
	cb_aceptar.enabled 		= false
else
	cb_aceptar.enabled = true
end if

If Key = KeyEnter! or Key=KeyTab! Then
	li_ano = integer( this.text )

	of_retrieve(li_ano)

end if
end event

type cb_aceptar from commandbutton within w_pt318_proy_prec_art
integer x = 1403
integer y = 12
integer width = 343
integer height = 100
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

event clicked;of_retrieve( integer(em_ano.text))
end event

