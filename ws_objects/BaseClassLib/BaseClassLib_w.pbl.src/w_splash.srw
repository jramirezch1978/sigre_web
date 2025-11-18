$PBExportHeader$w_splash.srw
forward
global type w_splash from window
end type
type cb_1 from commandbutton within w_splash
end type
type st_version from statictext within w_splash
end type
type p_logo from picture within w_splash
end type
type st_2 from statictext within w_splash
end type
type p_imagesplash from picture within w_splash
end type
end forward

global type w_splash from window
integer width = 2574
integer height = 1672
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
st_version st_version
p_logo p_logo
st_2 st_2
p_imagesplash p_imagesplash
end type
global w_splash w_splash

type variables


end variables

on w_splash.create
this.cb_1=create cb_1
this.st_version=create st_version
this.p_logo=create p_logo
this.st_2=create st_2
this.p_imagesplash=create p_imagesplash
this.Control[]={this.cb_1,&
this.st_version,&
this.p_logo,&
this.st_2,&
this.p_imagesplash}
end on

on w_splash.destroy
destroy(this.cb_1)
destroy(this.st_version)
destroy(this.p_logo)
destroy(this.st_2)
destroy(this.p_imagesplash)
end on

event resize;p_ImageSplash.x = 0
p_ImageSplash.y = 0
p_ImageSplash.width = newwidth
p_ImageSplash.height = newheight
end event

event open;String ls_mensaje

//st_1.text = gnvo_app.is_sistema

//MessageBox('', gnvo_app.is_logo)
//p_logo.picturename = gnvo_app.is_logo
//p_ImageSplash.pictureName = gnvo_app.is_ImageSplash

st_version.text = "Todos los derechos reservados. Versión 1.0.1"
Timer(2)
end event

event timer;close(this)
end event

type cb_1 from commandbutton within w_splash
boolean visible = false
integer x = 1975
integer y = 296
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Imagenes"
end type

event clicked;string ls_docpath, ls_docname[]
integer li_i, li_cnt, li_rtn, li_filenum

li_rtn = GetFileOpenName("Select File", &
   ls_docpath, ls_docname[], "DOC", &
   + "JPG Files (*.jpg),*.jpg," &
   + "All Files (*.*), *.*", &
   "C:\SIGRE\resources", 18)
 

IF li_rtn < 1 THEN return

li_cnt = Upperbound(ls_docname)

// if only one file is picked, docpath contains the 
// path and file name

if li_cnt = 1 then
	p_logo.picturename = ls_docpath
else
	// if multiple files are picked, docpath contains the 
	// path only - concatenate docpath and docname
	for li_i=1 to li_cnt
		try
			p_logo.picturename = ls_docpath &
				+ "\" +(ls_docname[li_i])
			sleep(2)
		catch (Exception ex)
			MessageBox('Error al cargar la imagen', ex.getMessage())
		end try
	next
end if
end event

type st_version from statictext within w_splash
integer x = 201
integer y = 1404
integer width = 2258
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
alignment alignment = center!
boolean focusrectangle = false
end type

type p_logo from picture within w_splash
accessiblerole accessiblerole = graphicrole!
integer x = 1870
integer y = 28
integer width = 672
integer height = 240
string picturename = "C:\SIGRE\resources\JPG\LogoNPS.jpg"
boolean focusrectangle = false
boolean map3dcolors = true
string powertiptext = "Logo de la Empresa"
end type

type st_2 from statictext within w_splash
integer x = 201
integer y = 1524
integer width = 2258
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Poor Richard"
long textcolor = 65535
long backcolor = 8421376
string text = "Para la empresa moderna, para la empresa de hoy"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_imagesplash from picture within w_splash
integer width = 2560
integer height = 1656
string picturename = "C:\SIGRE\resources\JPG\11280.jpg"
boolean focusrectangle = false
end type

