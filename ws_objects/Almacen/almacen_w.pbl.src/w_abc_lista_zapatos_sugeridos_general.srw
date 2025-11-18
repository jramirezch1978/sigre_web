$PBExportHeader$w_abc_lista_zapatos_sugeridos_general.srw
forward
global type w_abc_lista_zapatos_sugeridos_general from w_abc
end type
type cb_cancel from commandbutton within w_abc_lista_zapatos_sugeridos_general
end type
type cb_aceptar from commandbutton within w_abc_lista_zapatos_sugeridos_general
end type
type dw_master from u_dw_abc within w_abc_lista_zapatos_sugeridos_general
end type
end forward

global type w_abc_lista_zapatos_sugeridos_general from w_abc
integer width = 3127
integer height = 1324
string title = "Listado de Zapatos Sugeridos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancel cb_cancel
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_abc_lista_zapatos_sugeridos_general w_abc_lista_zapatos_sugeridos_general

type variables
str_parametros 	istr_param
u_ds_base			ids_sugerencias
end variables

forward prototypes
public function string of_color (string ls_desc_color)
end prototypes

public function string of_color (string ls_desc_color);String 	ls_color

Long 		ll_count, ll_color

select count(*)
	into :ll_count
from color c
where NVL(trim(upper(c.descripcion)), '0') = NVL(trim(upper(:ls_desc_color)),'0');

if ll_count > 0 then
	select color
	into :ls_color
	from color c
	where NVL(trim(upper(c.descripcion)),'0') = NVL(trim(upper(:ls_desc_color)),'0');	
	return ls_color
end if

select NVL(max(c.color),0) + 1
	into :ll_color
from color c;

//Inserto el nuevo color
ls_color = trim(string(ll_color, '000'))

insert into color(color, descripcion, flag_estado)
values(:ls_color, :ls_desc_color, '1');

if gnvo_app.of_existsError(SQLCA, "Error al insertar en tabla COLOR") then
	rollback ;
	return ''
end if

commit;

/*if as_parametro = 'primario' then
	dw_master.object.color1					[1] = ls_color
	dw_master.object.color_primario		[1] = ls_desc_color
elseif as_parametro = 'secundario' then
	dw_master.object.color2					[1] = ls_color
	dw_master.object.color_secundario	[1] = ls_desc_color
else
	MessageBox('Error', 'Parametro ' + as_parametro + ' no esta implementado todavía. Por favor corrija', StopSign!)
	return ''
end if*/
return ls_color
end function

on w_abc_lista_zapatos_sugeridos_general.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.dw_master
end on

on w_abc_lista_zapatos_sugeridos_general.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros lstr_param
Long 				ll_talla_min, ll_talla_max, ll_row, ll_count
String				ls_mensaje, ls_cod_sub_cat
string 			ls_cod_suela, ls_desc_suela,  ls_cod_acabado, ls_desc_acabado, &
					ls_color1, ls_Color_primario, ls_color2, ls_color_secundario, &
					ls_cod_taco, ls_desc_taco, ls_und, ls_desc_unidad, &
					ls_Cod_clase, ls_desc_clase, ls_cod_sub_linea, ls_cod_linea,ls_abrev_linea, ls_estilo, ls_desc_sub_linea, ls_desc_linea
u_dw_abc			ldw_master					

//Validar la cantidad de registros con cantidad, tiene que haber puesto cantidad al menos
//en un registro
if dw_master.RowCount() = 0 then 
	MessageBox('Error', 'No hay registros de sugerencia, por favor verifique!', StopSign!)
	return
end if

if dw_master.getRow() = 0 then
	MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
	return 
end if

ldw_master = istr_param.dw_m

ll_row = dw_master.getRow()

//Obtengo los datos necesarios para los articulos

//ls_cod_suela 			= dw_master.object.cod_suela			[ll_row]

ls_desc_suela 			= dw_master.object.desc_suela			[ll_row]	
select count(1) into :ll_count
from zc_suela where desc_suela = trim(:ls_desc_suela);

if ll_count > 0 then	
	ls_desc_suela 			= dw_master.object.desc_suela			[ll_row]
	
	select cod_suela 
	into :ls_cod_suela
	from zc_suela 
	where trim(desc_suela) = trim(:ls_desc_suela);
end if;

// acabado 		
ls_desc_acabado 		= dw_master.object.desc_acabado		[ll_row]
select cod_acabado into :ls_cod_acabado
from zc_acabado
where desc_acabado = trim(:ls_desc_acabado);

//ls_color1		 		
ls_color_primario		= dw_master.object.color_primario	[ll_row]
ls_color1 = of_color(ls_color_primario)

//ls_color2 				
ls_color_secundario	= dw_master.object.color_secundario	[ll_row]
ls_color2 = of_color(ls_color_secundario)

//ls_cod_taco 			= dw_master.object.cod_taco			[ll_row]
ls_cod_taco			= dw_master.object.desc_taco			[ll_row]
select DESC_taco into :ls_desc_taco
from zc_taco
where trim(COD_TACO) =trim(:ls_cod_taco);

//linea
ls_desc_linea			= dw_master.object.desc_linea			[ll_row]
select cod_linea, abreviatura into :ls_cod_linea	, :ls_abrev_linea
from zc_linea
where trim(desc_linea) =trim(:ls_desc_linea);

//sublinea
ls_desc_sub_linea			= dw_master.object.desc_sublinea			[ll_row]
select cod_sub_linea into :ls_cod_sub_linea	
from zc_sublinea
where trim(desc_sub_linea) =trim(:ls_desc_sub_linea);

//unidad
 ls_und = dw_master.object.cod_unidad [ll_row];
 select desc_unidad into :ls_desc_unidad
 from unidad   
 where und = trim(:ls_und);

ls_estilo					= dw_master.object.estilo			[ll_row]
ls_cod_sub_cat			= dw_master.object.cod_sub_cat	[ll_row]

//Actualizo los datos en el datawindow anterior
ldw_master.object.cod_sub_cat		[1]  	=	ls_cod_sub_cat
ldw_master.object.estilo					[1]  	=	ls_estilo  
ldw_master.object.cod_linea			[1]  	= ls_cod_linea
ldw_master.object.desc_linea			[1]  	= ls_desc_linea
ldw_master.object.cod_sub_linea		[1]  	= ls_cod_sub_linea
ldw_master.object.desc_sub_linea		[1]     = ls_desc_sub_linea
ldw_master.object.abrev_linea			[1]  	= ls_abrev_linea
ldw_master.object.cod_suela			[1]  	= ls_cod_suela
ldw_master.object.desc_suela			[1]  	= ls_desc_suela
ldw_master.object.cod_acabado		[1]  	= ls_cod_acabado
ldw_master.object.desc_acabado		[1]  	= ls_desc_acabado
ldw_master.object.color1				[1]  	= ls_color1
ldw_master.object.color_primario		[1]  	= ls_color_primario
ldw_master.object.color2				[1]  	= ls_color2
ldw_master.object.color_secundario	[1]  	= ls_color_secundario
ldw_master.object.cod_taco				[1]  	= ls_cod_taco
ldw_master.object.desc_taco			[1]  	= ls_desc_taco
ldw_master.object.und					[1]  	= ls_und
ldw_master.object.desc_unidad		[1]  	= ls_desc_unidad


lstr_param.b_return = true

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;

istr_param = Message.PowerObjectParm

idw_1 = dw_master              				// asignar dw corriente

dw_master.Retrieve(istr_param.string1, istr_param.string2, istr_param.string3, istr_param.string4)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

end event

type cb_cancel from commandbutton within w_abc_lista_zapatos_sugeridos_general
integer x = 2683
integer y = 1104
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_aceptar from commandbutton within w_abc_lista_zapatos_sugeridos_general
integer x = 2258
integer y = 1104
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

type dw_master from u_dw_abc within w_abc_lista_zapatos_sugeridos_general
integer width = 3104
integer height = 1092
string dataobject = "d_list_sugerencias_zapatos_general_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event doubleclicked;call super::doubleclicked;parent.event ue_aceptar()
end event

