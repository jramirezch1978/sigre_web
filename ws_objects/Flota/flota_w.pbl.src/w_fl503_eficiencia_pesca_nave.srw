$PBExportHeader$w_fl503_eficiencia_pesca_nave.srw
forward
global type w_fl503_eficiencia_pesca_nave from w_abc
end type
type st_2 from statictext within w_fl503_eficiencia_pesca_nave
end type
type sle_dias from singlelineedit within w_fl503_eficiencia_pesca_nave
end type
type st_1 from statictext within w_fl503_eficiencia_pesca_nave
end type
type pb_recuperar from u_pb_std within w_fl503_eficiencia_pesca_nave
end type
type gr_1 from graph within w_fl503_eficiencia_pesca_nave
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl503_eficiencia_pesca_nave
end type
end forward

global type w_fl503_eficiencia_pesca_nave from w_abc
integer width = 2542
integer height = 1836
string title = "Eficiencia de Pesca - Flota Propia (FL503)"
string menuname = "m_smpl"
event ue_retrieve ( )
event ue_graph1 ( )
event ue_copiar ( )
st_2 st_2
sle_dias sle_dias
st_1 st_1
pb_recuperar pb_recuperar
gr_1 gr_1
uo_fecha uo_fecha
end type
global w_fl503_eficiencia_pesca_nave w_fl503_eficiencia_pesca_nave

type variables
u_ds_base 	ids_data
m_rb_graph 	im_graph
string		is_nave
end variables

forward prototypes
public subroutine of_copiar ()
end prototypes

event ue_retrieve();date ld_fecha1, ld_fecha2
integer li_ok, li_dias
string ls_mensaje

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

sle_dias.text = string(DaysAfter(ld_fecha1, ld_fecha2))
li_dias	= DaysAfter(ld_fecha1, ld_fecha2)

//create or replace procedure USP_FL_EFICIENCIAS(
//		adi_fecha1 	in date,
//    adi_fecha2 	in date,
//    ani_dias    IN NUMBER
//) is

DECLARE USP_FL_EFICIENCIAS PROCEDURE FOR
	USP_FL_EFICIENCIAS( :ld_fecha1,
							  :ld_fecha2,
							  :li_dias );

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
string 	ls_nave
decimal 	ln_efpesca
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

ids_data.DataObject = 'ds_eficiencias_grid'
ids_data.SetTransObject(SQLCA)
ids_data.Retrieve()

gr_1.SetRedraw(false)
gr_1.Reset( All! )
li_Series 	= gr_1.AddSeries("Eficiencia Pesca")


for li_x = 1 to ids_data.RowCount()
	ls_nave 		= ids_data.object.nomb_nave[li_x]
	ln_efpesca	= ids_data.object.efic_captura[li_x]
	
	li_rtn 		= gr_1.AddData( li_Series, ln_efpesca, ls_nave )
	
next

gr_1.Title = "Eficiencia de Captura (" &
	+ string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
	+ string(ld_fecha2, 'dd/mm/yyyy') + ')'

gr_1.SetRedraw(true)
end event

event ue_copiar();gr_1.ClipBoard( )
end event

public subroutine of_copiar ();gr_1.ClipBoard( )
end subroutine

on w_fl503_eficiencia_pesca_nave.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.st_2=create st_2
this.sle_dias=create sle_dias
this.st_1=create st_1
this.pb_recuperar=create pb_recuperar
this.gr_1=create gr_1
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_dias
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.pb_recuperar
this.Control[iCurrent+5]=this.gr_1
this.Control[iCurrent+6]=this.uo_fecha
end on

on w_fl503_eficiencia_pesca_nave.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_dias)
destroy(this.st_1)
destroy(this.pb_recuperar)
destroy(this.gr_1)
destroy(this.uo_fecha)
end on

event resize;call super::resize;this.SetRedraw(false)
gr_1.width  = newwidth  - gr_1.x - 10
gr_1.height = newheight - gr_1.y - 10
st_1.y = newheight - st_1.height 
st_1.width  = newwidth  - st_1.x - 10
this.SetRedraw(true)
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

type st_2 from statictext within w_fl503_eficiencia_pesca_nave
integer x = 1403
integer y = 52
integer width = 425
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dias Diponibles"
boolean focusrectangle = false
end type

type sle_dias from singlelineedit within w_fl503_eficiencia_pesca_nave
integer x = 1851
integer y = 48
integer width = 261
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event getfocus;Date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

this.text = string(DaysAfter(ld_fecha1, ld_fecha2))
end event

type st_1 from statictext within w_fl503_eficiencia_pesca_nave
integer x = 37
integer y = 1500
integer width = 1989
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_recuperar from u_pb_std within w_fl503_eficiencia_pesca_nave
integer x = 2249
integer y = 16
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

type gr_1 from graph within w_fl503_eficiencia_pesca_nave
integer y = 168
integer width = 2405
integer height = 1412
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
grsorttype seriessort = ascending!
grsorttype categorysort = ascending!
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
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Times New Roman"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Roman!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.AutoSize=true
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
Values.Label="% Eficiencia"
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MajorGridLine=transparent!
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

event doubleclicked;grObjectType	ClickedObject
int		li_Rtn, li_Series, li_Category
date 		ld_fecha1, ld_fecha2
string 	ls_nave

ClickedObject = this.ObjectAtPointer(li_Series, li_category)

if ClickedObject = TypeData! &
	or ClickedObject = TypeCategory! then
	
	ls_nave = this.CategoryName(li_Category)
	ld_fecha1 = uo_fecha.of_get_fecha1()
	ld_fecha2 = uo_fecha.of_get_fecha2()
	OpenSheet(w_pop_grf, w_main, 0, Original!)

	w_pop_grf.event dynamic ue_gr01('Detalle de la nave: ' &
		+ ls_nave, ls_nave, ld_fecha1, ld_fecha2)
	
else
	MessageBox(Parent.Title, "Haga Click en alguna " &
		+"nave para mostrar informacion detallada", &
		Information!)
end if

end event

event clicked;grObjectType	ClickedObject
int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad
long ll_row


ClickedObject = this.ObjectAtPointer(li_Series, li_category)

if ClickedObject = TypeData! &
	or ClickedObject = TypeCategory! then
	
	ls_categ = this.CategoryName(li_Category)
	ls_serie = this.SeriesName(li_Series)
	
	ls_cantidad = string(this.GetData(li_series, li_category), '###,##0.00')
	
	
	st_1.text = ls_serie + ' - ' + ls_categ &
			+ ' Cantidad: ' + ls_cantidad + ' %'
	
else
	MessageBox(Parent.Title, "Haga Click en alguna " &
		+"barra que desee consultar", &
		Information!)
end if
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl503_eficiencia_pesca_nave
event destroy ( )
integer x = 73
integer y = 44
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

