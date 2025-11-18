$PBExportHeader$w_fl516_captura_naves.srw
forward
global type w_fl516_captura_naves from w_abc
end type
type rb_2 from radiobutton within w_fl516_captura_naves
end type
type rb_1 from radiobutton within w_fl516_captura_naves
end type
type pb_recuperar from u_pb_std within w_fl516_captura_naves
end type
type gr_1 from graph within w_fl516_captura_naves
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl516_captura_naves
end type
end forward

global type w_fl516_captura_naves from w_abc
integer width = 2286
integer height = 1836
string title = "Captura por Especie x Nave - Flota Propia (FL516)"
string menuname = "m_smpl"
event ue_retrieve ( )
event ue_graph1 ( )
event ue_copiar ( )
rb_2 rb_2
rb_1 rb_1
pb_recuperar pb_recuperar
gr_1 gr_1
uo_fecha uo_fecha
end type
global w_fl516_captura_naves w_fl516_captura_naves

type variables
u_ds_base 	ids_data
m_rb_graph 	im_graph
string		is_nave
end variables

forward prototypes
public subroutine of_copiar ()
end prototypes

event ue_retrieve();date ld_fecha1, ld_fecha2
integer li_ok
string ls_mensaje
Long	 ll_nro_dias

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

//create or replace procedure USP_FL_EFICIENCIAS(
//		adi_fecha1 	in date,
//    adi_fecha2 	in date,
//    ani_dias    IN NUMBER) is

ll_nro_dias = DaysAfter(ld_fecha1, ld_fecha2)

DECLARE USP_FL_EFICIENCIAS PROCEDURE FOR
	USP_FL_EFICIENCIAS( :ld_fecha1, :ld_fecha2, :ll_nro_dias );

EXECUTE USP_FL_EFICIENCIAS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_EFICIENCIAS: " &
		+ SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_FL_EFICIENCIAS;

this.event ue_graph1()

end event

event ue_graph1();Integer 	li_Series, li_rtn, li_x
string 	ls_nave, ls_especie
decimal 	ln_pesca, ln_arribos
date 		ld_fecha1, ld_fecha2

gr_1.SetRedraw(false)
gr_1.Reset( All! )

ids_data.DataObject = 'ds_especies'
ids_data.SetTransObject(SQLCA)
ids_data.Retrieve()

for li_x = 1 to ids_data.RowCount()
	ls_especie 	= ids_data.object.descr_especie[li_x]
	li_Series 	= gr_1.AddSeries(ls_especie)
next

ld_fecha1 =	uo_fecha.of_get_fecha1()
ld_fecha2 =	uo_fecha.of_get_fecha2()

ids_data.DataObject = 'ds_capt_especie_nave_bar_graph'
ids_data.SetTransObject(SQLCA)
ids_data.Retrieve(ld_fecha1, ld_fecha2)

for li_x = 1 to ids_data.RowCount()
	ls_nave 		= ids_data.object.nave[li_x]
	ls_especie	= ids_data.object.especie[li_x]
	ln_pesca		= ids_data.object.pesca[li_x]
	li_Series	= gr_1.FindSeries(ls_especie)
	
	gr_1.AddData( li_Series, ln_pesca, ls_nave )
next

gr_1.Title = "Captura por Especie por Nave"

gr_1.SetRedraw(true)
end event

event ue_copiar();gr_1.ClipBoard( )
end event

public subroutine of_copiar ();gr_1.ClipBoard( )
end subroutine

on w_fl516_captura_naves.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_recuperar=create pb_recuperar
this.gr_1=create gr_1
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.pb_recuperar
this.Control[iCurrent+4]=this.gr_1
this.Control[iCurrent+5]=this.uo_fecha
end on

on w_fl516_captura_naves.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_recuperar)
destroy(this.gr_1)
destroy(this.uo_fecha)
end on

event resize;call super::resize;gr_1.width  = newwidth  - gr_1.x - 10
gr_1.height = newheight - gr_1.y - 10


end event

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2
ids_data = CREATE u_ds_base
im_graph = create m_rb_graph

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

event close;call super::close;destroy ids_data
destroy im_graph
end event

type rb_2 from radiobutton within w_fl516_captura_naves
integer x = 1413
integer y = 96
integer width = 544
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Columnas Agrupadas"
boolean checked = true
end type

event clicked;gr_1.GraphType = col3dObjGraph!

end event

type rb_1 from radiobutton within w_fl516_captura_naves
integer x = 1417
integer y = 28
integer width = 485
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Columnas Unicas"
end type

event clicked;gr_1.GraphType = ColStack3DObjGraph!
end event

type pb_recuperar from u_pb_std within w_fl516_captura_naves
integer x = 2071
integer y = 24
integer width = 155
integer height = 132
integer taborder = 30
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

type gr_1 from graph within w_fl516_captura_naves
integer y = 216
integer width = 2226
integer height = 1364
boolean border = true
grgraphtype graphtype = col3dobjgraph!
long textcolor = 33554432
long backcolor = 16777215
integer spacing = 100
integer elevation = 6
integer rotation = -33
integer perspective = 7
integer depth = 100
grlegendtype legend = atbottom!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

on gr_1.create
TitleDispAttr = create grDispAttr
LegendDispAttr = create grDispAttr
PieDispAttr = create grDispAttr
Series = create grAxis
Series.DispAttr = create grDispAttr
Series.LabelDispAttr = create grDispAttr
Category = create grAxis
Category.DispAttr = create grDispAttr
Category.LabelDispAttr = create grDispAttr
Values = create grAxis
Values.DispAttr = create grDispAttr
Values.LabelDispAttr = create grDispAttr
TitleDispAttr.Weight=700
TitleDispAttr.FaceName="Arial"
TitleDispAttr.FontCharSet=DefaultCharSet!
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=536870912
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.Label="Naves Propias"
Category.AutoScale=true
Category.ShadeBackEdge=true
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.OriginLine=transparent!
Category.MajorTic=Outside!
Category.DataType=adtText!
Category.DispAttr.TextSize=13
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Arial"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Swiss!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Arial"
Category.LabelDispAttr.FontCharSet=DefaultCharSet!
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Arial"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=400
Values.LabelDispAttr.FaceName="Arial"
Values.LabelDispAttr.FontCharSet=DefaultCharSet!
Values.LabelDispAttr.FontFamily=Swiss!
Values.LabelDispAttr.FontPitch=Variable!
Values.LabelDispAttr.Alignment=Center!
Values.LabelDispAttr.BackColor=536870912
Values.LabelDispAttr.Format="[General]"
Values.LabelDispAttr.DisplayExpression="valuesaxislabel"
Values.LabelDispAttr.AutoSize=true
Values.LabelDispAttr.Escapement=900
Series.Label="(None)"
Series.AutoScale=true
Series.SecondaryLine=transparent!
Series.MajorGridLine=transparent!
Series.MinorGridLine=transparent!
Series.DropLines=transparent!
Series.OriginLine=transparent!
Series.MajorTic=Outside!
Series.DataType=adtText!
Series.DispAttr.Weight=400
Series.DispAttr.FaceName="Arial"
Series.DispAttr.FontCharSet=DefaultCharSet!
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=536870912
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.DispAttr.AutoSize=true
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Arial"
Series.LabelDispAttr.FontCharSet=DefaultCharSet!
Series.LabelDispAttr.FontFamily=Swiss!
Series.LabelDispAttr.FontPitch=Variable!
Series.LabelDispAttr.Alignment=Center!
Series.LabelDispAttr.BackColor=536870912
Series.LabelDispAttr.Format="[General]"
Series.LabelDispAttr.DisplayExpression="seriesaxislabel"
Series.LabelDispAttr.AutoSize=true
LegendDispAttr.Weight=400
LegendDispAttr.FaceName="Arial"
LegendDispAttr.FontCharSet=DefaultCharSet!
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=536870912
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
LegendDispAttr.AutoSize=true
PieDispAttr.Weight=400
PieDispAttr.FaceName="Arial"
PieDispAttr.FontCharSet=DefaultCharSet!
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on gr_1.destroy
destroy TitleDispAttr
destroy LegendDispAttr
destroy PieDispAttr
destroy Series.DispAttr
destroy Series.LabelDispAttr
destroy Series
destroy Category.DispAttr
destroy Category.LabelDispAttr
destroy Category
destroy Values.DispAttr
destroy Values.LabelDispAttr
destroy Values
end on

event rbuttondown;im_graph.PopMenu(w_main.PointerX(), w_main.PointerY())

end event

type uo_fecha from u_ingreso_rango_fechas within w_fl516_captura_naves
event destroy ( )
integer x = 18
integer y = 40
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

