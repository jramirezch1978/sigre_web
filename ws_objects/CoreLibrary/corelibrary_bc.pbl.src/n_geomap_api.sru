$PBExportHeader$n_geomap_api.sru
forward
global type n_geomap_api from nonvisualobject
end type
end forward

global type n_geomap_api from nonvisualobject
end type
global n_geomap_api n_geomap_api

type variables
String ls_DirFile=''// para el archivo temporal usaremos los mismo pero adicionamos 't' a la extencion de temporal
String is_script //Almacena el script completo de la pagina de google map a ser modificada
String is_scriptInsert //Script a insertar
long li_LongCarStript //tamaño de caracteres de script

Boolean lb_isMAPLok=false//verifica si se cargo el mapa correctamente y marca la pauta para todo las demas funciones
Boolean lb_renderizado=false
//Variables para capturar algune error
String is_error
String is_lastError
Integer ii_errorCod

//Varible constantes del tipo de mapa 
constant String ROADMAP='ROADMAP',SATELLITE="SATELLITE", HYBRID ="HYBRID", TERRAIN="TERRAIN"
String is_typemap='ROADMAP'

//variables para identificar si los puntos de mapa estan ya graficados
Boolean lb_isGraficaPoint=false

//api_key de googlemap
String is_ApiKey

//Lat y Long donde iniciara todo Lima
String is_lat='-12.0278733333333'
String is_lon='-77.1018826666667'
String is_zoom=''

/*VISTASSS*/
	STRING is_angulo=''

//***********COORDENADAS A GRAFICAR EN EL MARKER
	//imagenes
	String ls_imagen[]
	//PUNTOS
	String is_XX[], is_YY[]
	integer ii_nro_puntos
	//DESCRIPCIONES DEL PUNTO
	String is_descripcion[]
	//animaicon de punto
	String is_tipo_animation[]
//******************************

//temportales
String is_vacio[]
Constant String is_anima_BOUNCE='google.maps.Animation.BOUNCE'
Constant String is_anima_DROP='google.maps.Animation.DROP'
end variables

forward prototypes
public function string of_geterror ()
public function string of_getlasterror ()
public function string of_getscript ()
private subroutine f_seterror (integer ls_errornro, string ls_errortext)
public function integer of_settype_map (string _type)
public function integer of_set_zoom (integer _zoom)
public function integer of_destroyall ()
public function integer of_setfilemap (string _dir)
public function string of_geturl ()
private function integer f_changetext (string _txtini[], string _txtfin, string text_remplazo)
public function integer of_renderizar ()
public function boolean of_ismapactive ()
protected subroutine f_setsourcefile (integer _type, string _script)
protected subroutine f_create_body ()
public subroutine of_setkeymap (string _key)
public function integer f_setimage (string _nombre)
public function integer f_setimage (string _nombre[])
private function integer f_create_header ()
public subroutine of_vistadiagonal (string _ang)
public subroutine of_setpuntos_coord (string _x, string _y, string _img, string _descrption, string _type_anima)
public function integer of_setcordenadas_area (string _lat, string _long)
end prototypes

public function string of_geterror ();return is_error
end function

public function string of_getlasterror ();return is_lastError
end function

public function string of_getscript ();/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015
Descripcion:
	Retorna el script del archivo temporal generado
*/
long ll_file
ll_file = FileOpen(ls_DirFile+"t", StreamMode!)
IF ll_file>0  THEN
    FileRead ( ll_file, is_script )
	fileclose(ll_file)
end if

return is_script
end function

private subroutine f_seterror (integer ls_errornro, string ls_errortext);//actualiza el error descrito en alguna parte del objeto
is_lastError=is_error
is_error=ls_errorText
ii_errorCod=ls_errorNro
end subroutine

public function integer of_settype_map (string _type);if of_ismapactive() then
	if not lb_renderizado then
		is_typemap=_type
	else
		choose case _type
			case ROADMAP, SATELLITE, HYBRID,TERRAIN
				is_typemap=_type
				return f_changetext({'google.maps.MapTypeId','MapTypeId','.'}, '}', _type)	
			case else
				f_seterror( 1060,"Tipo de mapa desconocido("+_type+")")
				return 0
		end choose
	end if
else
	f_seterror( 1064,"Mapa no iniciado")
	return 0
end if
end function

public function integer of_set_zoom (integer _zoom);/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015
Descripcion:
	Configura la posicion de zoom del map del google map en un rango
	de 0 a 20 siendo 0 el zoom mas lejano y 20 el mas cercano

Retorno:	0 si ocurrio algun error, 1 si posiciono el zoom correctamente
*/
if _zoom>20 or _zoom<0 and of_ismapactive() then 
	this.f_seterror( 1071,"Zoom tiene formato [0-20], o el mapa no esta activo")
	return 0
else
	is_zoom=string(_zoom)
	if lb_renderizado then
		return f_changetext({'function initialize','zoom',':'}, ',', string(_zoom))
	end if
end if

//funcion esta ok pero no funcional se cro una funcion universar
/*
long ll_posinitialize, ll_tmp, ll_posfin, ll_tamCar
string ls_PartScript

ll_posinitialize=pos( is_script, 'function initialize')
IF ll_posinitialize>0 THEN
	ll_tmp=pos( is_script, 'zoom',ll_posinitialize)
	ll_tmp=pos( is_script, ':',ll_tmp)
	
	if ll_tmp>0 then
		ll_posfin=pos( is_script, ',',ll_tmp) -1
		ll_tamCar=len(is_script)
		ls_PartScript=Left ( is_script, ll_tmp )
		is_script=Right ( is_script, ll_tamCar -  ll_posfin)
		is_script= ls_PartScript + string(li_zoom)+is_script

		RETURN 1
	else
		f_setError(1050,"Error en script, no existe sintaxis zoom")
		RETURN 0
	end if
ELSE
	f_setError(1051,"Error en script, no existe function initialize")
	RETURN 0
END IF*/
end function

public function integer of_destroyall ();/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015
Descripcion:
	Es la primera funcion a ejecutar dado que resetea todos los valores
	asi como elimina el archivo temporarl, creado con anterioridad
*/

ls_DirFile=GetcurrentDirectory()+'\mapa.html'
if fileExists(ls_DirFile+"t") then
	FileDelete ( ls_DirFile+"t" )
end if
is_script=''
lb_isMAPLok=false

ls_imagen=is_vacio
is_XX=is_vacio
is_YY=is_vacio
is_descripcion=is_vacio
is_tipo_animation=is_vacio

ii_nro_puntos=0

is_angulo=''
is_zoom=''

is_error=''
is_lastError=''
ii_errorCod=0

return 1
end function

public function integer of_setfilemap (string _dir);/*Inicializa los datos de javascript a modificar
seteando los valores del archivo 
Codigo de error: 100x-110x
*/
ls_DirFile=_dir

if fileExists(ls_DirFile) then
	if upper(Right(ls_DirFile, 4 ))='HTML' or  upper(Right(ls_DirFile, 3))='TXT'  then
		integer li_FileNum
		li_FileNum = FileOpen(_dir, StreamMode!,Read!,LockRead!)
		IF li_FileNum>0 THEN
			FileRead (li_FileNum, is_script )
			clipboard(is_script)
			fileclose(li_FileNum)
			
			// ponemos la bandera en true de activo
			lb_isMAPLok=true
			//Actualizamos el mapa temporal
			f_setsourcefile(1,'')
			
			return 1
		ELSE
			f_seterror(1002,'El Archivo esta en uso o bloquedo, imposible tener acceso al contenido')
			return 0
		END IF
	else
		f_seterror(1002,'Archivo desconocido, formato no valido(Solo se permieten formatos HTML o TXT)')
		return 0
	end if
else
	f_seterror(1001,'Archivo no existe o se cambio de directorio, Verificar')
	return 0
end if
end function

public function string of_geturl ();/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015

Descripcion:
	Retorna el path del archivo temportal creado
*/
if of_ismapactive( ) then
	return ls_DirFile+'t'
else
	this.f_seterror( 1241,'Mapa no activo, verificar')
	return ''
end if


end function

private function integer f_changetext (string _txtini[], string _txtfin, string text_remplazo);/*f_changeText
Echo por 	: 	Elvis Cardenas Zegarra
fecha 		:	14/05/2015

Esta funcion tiene por finalidad cambiar un texto por otro pasando como parametros los textos que la limitan, 
tener un minimo de 1 caracter para ser validados, y actualiza la nueva cantidad de caracteres que tiene el script.
Para el aplicativo GEO_MAP(En realidad no reemplaza solo lo omite al ser actualizado)
*/
integer li_index, li_tope
long ll_posini=1,ll_postmpini,ll_posfin
boolean lb_error=false
string ls_part1, ls_parte2

li_tope=UpperBound(_txtini)

if li_tope>0 then
	is_script=of_getscript( )
	//primero buscamos el inicio del texto cerrandolo segun los parametros enviados
	for li_index=1 to li_tope
		if len(_txtini[li_index])>0 then
			ls_part1=_txtini[li_index]
			//clipboard(is_script)
			ll_posini=pos(is_script, ls_part1 ,ll_posini )
			//ll_posfin=pos(is_script, 'function initialize' ,ll_posini )
			ll_postmpini++
			
		else
			li_index=li_tope +1
			lb_error=true
		end if
	next
	if lb_error or ll_postmpini<>li_tope then
		f_seterror(1021, "Parametros incorrectos de busqueda, no se permite vacios cuando el tope de indices es mayor al arreglo enviado")
		return 0
	else
		if len(_txtfin)>0 then
			li_LongCarStript=len(is_script)
			//capturando la parte 1, script dividio en 2 y luego unido
			ls_part1=Left(is_script, ll_posini)
			//identificando la posicion del caracter inmediato de fin
			ll_posfin=pos(is_script,_txtfin,ll_posini) -1
			//extrayendo la segunda parte
			ls_parte2=Right ( is_script,li_LongCarStript - ll_posfin)
			//uniendo las partes
			is_script=ls_part1+text_remplazo+ls_parte2
			li_LongCarStript=len(is_script)
			
			//actualizamo el archivo temporal
			f_setsourcefile(1,'')
			return 1
		else
			f_seterror(1022, "Texto de busqueda de posicion final tiene que tener algun caracter")
			return 0
		end if
	end if

else
	f_seterror(1021, "No se identifico las posiciones de busqueda, ingrese los textos")
	return 0
end if

end function

public function integer of_renderizar ();/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015

Descripcion:
	Construye el archivo HTML graficando los puntos en el mapa
	1) contruye el header, si ocurrio algun problem a retorna 0
	2) si esta todo correcto 1, contruye el body
*/
string ls_text
//verifican do el directorio
ls_DirFile=GetcurrentDirectory()+'\mapa.html'

//ponemos mapa ok
lb_isMAPLok=true

//creamos el archivo
ls_text='<!DOCTYPE html> <html>'
f_setsourcefile( 2,ls_text)

if f_create_header( )=0 then 
	of_destroyall( )
	return 0
end if
f_create_body( )

ls_text='</html>'
f_setsourcefile( 2,ls_text)

//actualizamos el renderizado a true
lb_renderizado=true

return 1
end function

public function boolean of_ismapactive ();return lb_isMAPLok
end function

protected subroutine f_setsourcefile (integer _type, string _script);/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015

Descripcion:
	escribe en el archivo temporal el codigo html
	//1=reemplaza el html del file
	//2=escribe al final del arhivo*/
	
if of_ismapactive( ) then
	long ll_file
	if _type=1 then
		ll_file = FileOpen(ls_DirFile+'t', StreamMode!,Write!,LockWrite!,Replace!)
	else
		ll_file = FileOpen(ls_DirFile+'t', StreamMode!,Write!,LockWrite!,Append!)
	end if
	IF ll_file>0  THEN
		if trim(_script)='' then _script=is_script
		FileWrite ( ll_file, "~n "+_script)
		fileclose(ll_file)
	end if
end if
end subroutine

protected subroutine f_create_body ();/*Drescripcion: crea el cuerpo De texto a ser Ejecutado en el MAP
Fecha	:	18052015
Por	:	Elvis Cardenas Z.

Descripcion:
	crea el HTML definido apra el body en el archivo temporal
*/

String ls_body
if of_ismapactive( ) then
	
	ls_body ='  <body>'
	f_setsourcefile( 2,ls_body)
	ls_body=' 		<div id="map-canvas"></div>'
	f_setsourcefile( 2,ls_body)
	ls_body='  </body>'
	f_setsourcefile( 2,ls_body)
end if
end subroutine

public subroutine of_setkeymap (string _key);is_ApiKey=_key
end subroutine

public function integer f_setimage (string _nombre);integer li_img
li_img=upperbound(ls_imagen)
ls_imagen[li_img +1 ]=_nombre

return 1
end function

public function integer f_setimage (string _nombre[]);ls_imagen=_nombre

return 1
end function

private function integer f_create_header ();/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015

Descripcion:	crea el header del html*/

string ls_header
integer li_index
if of_ismapactive( ) then
	ls_header='<head>'
	F_setsourcefile( 2,ls_header)
	
	ls_header='<meta name="viewport" content="initial-scale=1.0, user-scalable=no">'
	F_setsourcefile( 2,ls_header)
	ls_header='<meta charset="utf-8">'
	F_setsourcefile( 2,ls_header)
	ls_header='<title>GEOMAP</title>'
	F_setsourcefile( 2,ls_header)
	
	//creando el estilo
	ls_header='<style>'
	F_setsourcefile( 2,ls_header)
	ls_header='html, body, #map-canvas {'
	F_setsourcefile( 2,ls_header)
	ls_header='height: 100%; margin: 0px; padding: 0px}'
	F_setsourcefile( 2,ls_header)
	ls_header='</style>'
	F_setsourcefile( 2,ls_header)
	
	//creando s cript de google map
	ls_header='<script src="http://maps.googleapis.com/maps/api/js?key='+is_ApiKey+'&sensor=FALSE"></script> <script>'
	F_setsourcefile( 2,ls_header)
	
		//creando la funciona que inicializa todo
		ls_header='function initialize() {'
		F_setsourcefile( 2,ls_header)
		
		if is_zoom='' then is_zoom='12'
		ls_header='var mapOptions = {zoom: '+is_zoom+","
		F_setsourcefile( 2,ls_header)
		ls_header='	center: new google.maps.LatLng('+is_lat+',' +is_lon+' ),mapTypeId: google.maps.MapTypeId.'+is_typemap+'}'
		F_setsourcefile( 2,ls_header)
		ls_header="var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);"
		F_setsourcefile( 2,ls_header)
		
		//verificando si tiene angulo de entrada
		if is_angulo<>'' then
			ls_header="map.setTilt("+is_angulo+");"
			F_setsourcefile( 2,ls_header)
		end if
		
		ls_header='setMarkers(map, puntos);}'
		F_setsourcefile( 2,ls_header)
		
		//creando los puntos a graficar
		ls_header='var puntos = ['
		F_setsourcefile( 2,ls_header)
		
		//string puntosX[]={'-12.0278733333333','-12.0218733333333','-12.0236733333333','-12.0436733333333','-12.04733333333'}
		//string puntosY[]={'-77.1228826666667','-77.121526666667','-77.12656666667','-77.127566667','-77.1285266667'}
		if ii_nro_puntos=0 then 
			return 0
		end if
		for li_index=1 to ii_nro_puntos
			ls_header="['"+is_descripcion[li_index]+"',"+is_XX[li_index]+","+is_YY[li_index]+", "+string(li_index)+","+is_tipo_animation[li_index]+"],"
			F_setsourcefile( 2,ls_header)
		next
		ls_header='];'
		F_setsourcefile( 2,ls_header)
		
		//graficando los puntos en el mapa
		ls_header='function setMarkers(map, locations) {'
		F_setsourcefile( 2,ls_header)
			/*ls_header="  	var image = {url: 'imagenes/1.png',"
			F_setsourcefile( 2,ls_header)
			ls_header="//	size: new google.maps.Size(20, 32),"
			F_setsourcefile( 2,ls_header)
			ls_header="	origin: new google.maps.Point(0,0),"
			F_setsourcefile( 2,ls_header)
			ls_header="	anchor: new google.maps.Point(0, 32)"
			F_setsourcefile( 2,ls_header)
			ls_header="  };"*/
			integer li_inf
			li_inf=UpperBound(ls_imagen)
			if li_inf=0 then 
				ls_header="var image = ['imagenes/1.png'];"
			else
				ls_header="var image = ["
				for li_index=1 to li_inf - 1
					ls_header+="'"+ls_imagen[li_index]+"',"
				next
				ls_header+="'"+ls_imagen[li_index]+"'];"
			end if
			
			F_setsourcefile( 2,ls_header)
			
			//dibujando el poligono
			ls_header="   var shape = {coords: [1, 1, 1, 20, 18, 20, 18 , 1], type: 'poly'};"
			F_setsourcefile( 2,ls_header)
			ls_header="	for (var i = 0; i < locations.length; i++) {"
			F_setsourcefile( 2,ls_header)
			ls_header="	var punto = locations[i];"
			F_setsourcefile( 2,ls_header)
			ls_header="	var myLatLng = new google.maps.LatLng(punto[1], punto[2]);"
			F_setsourcefile( 2,ls_header)
			ls_header="	var marker = new google.maps.Marker({"
			F_setsourcefile( 2,ls_header)
			ls_header="	position: myLatLng,"
			F_setsourcefile( 2,ls_header)
			ls_header="	map: map,"
			F_setsourcefile( 2,ls_header)
			ls_header="	icon: image[i],"
			F_setsourcefile( 2,ls_header)
			ls_header="	shape: shape,"
			F_setsourcefile( 2,ls_header)
			ls_header="	title: punto[0],"
			F_setsourcefile( 2,ls_header)
			ls_header="	zIndex: punto[3],"
			F_setsourcefile( 2,ls_header)
			ls_header="	animation: punto[4]"
			F_setsourcefile( 2,ls_header)
			ls_header="	 });  }"
			F_setsourcefile( 2,ls_header)
		ls_header="}"
		F_setsourcefile( 2,ls_header)
	
	ls_header="	google.maps.event.addDomListener(window, 'load', initialize);"
	F_setsourcefile( 2,ls_header)
	ls_header="</script> "
	F_setsourcefile( 2,ls_header)
	ls_header="</head>"
	F_setsourcefile( 2,ls_header)
	return 1
else
	f_seterror(3215, "Error conrtuyendo header, Mapa no activo")
	return 0
	
end if
end function

public subroutine of_vistadiagonal (string _ang);is_angulo=_ang

end subroutine

public subroutine of_setpuntos_coord (string _x, string _y, string _img, string _descrption, string _type_anima);/*GEOMAP API GOOGLE MAP V3
by	:	Elvis Cardenas Zegarra
Fecha de creacion	:	14/05/2015

Descripcion:
	setea todos los valores para crear el punto a graficar en el mapa
*/
ii_nro_puntos=upperbound(is_XX)
ii_nro_puntos++
is_XX[ii_nro_puntos]=_x
is_YY[ii_nro_puntos]=_y
ls_imagen[ii_nro_puntos]=_img
is_descripcion[ii_nro_puntos]=_descrption
is_tipo_animation[ii_nro_puntos]=_type_anima
	//

end subroutine

public function integer of_setcordenadas_area (string _lat, string _long);/*
Echo por : Elvis Cardenas Zegarra - UNS - CHIMBOTE :D
Funcion que posiciona las coordenadas de a buscar en el mapa
Parametros de envio son la latitud y la longitud en string

*/

if len(_lat)>1 and  len(_long)>1 and of_ismapactive() then
	is_lat=_lat
	is_lon=_long
	if lb_renderizado then
		return f_changetext({'google.maps.LatLng','('}, ')', _lat+", "+_long)
	end if
	
else
	this.f_seterror( 5012, "No se envio las coordenadas Lat. y Long. adecuadamente o no se inicio el MAPA")
	 return 0
end if

end function

on n_geomap_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_geomap_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*GEOMAP API GOOGLE MAP V3
Nombre de la biblioteca	: n_geomap_api
Version						: 1.0
Desarrollado por			: Elvis Cardenas Zegarra
Fecha de creacion			: 14/05/2015
fecha de revision			: 20/05/2015

Descripcion:
	Crea un archivo HTML modificado segun coordenadas y posiciones pasadas como parametros para 
	ser graficados en el GoogleMAP V3
	**El buscador ole de powerbuilder por default es version 7, GoogleMAP no funciona ya con esa version
		(te encomiendo la tarea de averiguarla como poner esa version a uno superior yo ya lo hice, no todo es masticado)
	
Forma de uso:
	1) crear la instancia 
		n_geomap_api uo_geomap
		uo_geomap=create n_geomap_api
	2) pasar los parametro por las funciones establecidas y renderizar la aplicacion
	
		//limpiando datos anteriores
		uo_geomap.of_destroyall( )
		
		//llave de map Y ZOOM
		uo_geomap.of_setKeyMap("TuKeyAPI")
		uo_geomap.of_set_zoom(12)
		
		//estructura de opuntos a graficar
		string descr[]={"descripcion 1", "descripcion 2"}
		string img[]={"1.png", "2.png"}
		string puntosX[]={'-12.0278733333333','-12.0218733333333'}
		string puntosY[]={'-77.1228826666667','-77.121526666667'}
		string anima[]={uo_geomap.is_anima_drop, uo_geomap.is_anima_bounce}
		
		//graficamos el marcador
		for li_err=1 to 2
			uo_geomap.of_setpuntos_coord( puntosX[li_err], puntosY[li_err], img[li_err], descr[li_err], anima[li_err] )
		next 
		
		//renderizamos la grafica si todo esta bien retorna 1 sino 0
		if uo_geomap.of_renderizar( )=0 then
			messagebox("error",uo_geomap.of_geterror( ) )
		end if
	
	3) puede obtener la url del archivo luego a ser cardago en el Explorador web
		ole_web.of_navigate(uo_geomap.of_geturl( ) )
		
Nota:
	Ensima que te enseño me quitaras la propiedad intelectual?? no te pases pues respeta,  Gracias :D
	
*/
//*==============================================================================
/*
//ESTRUCTURA A SIMULAR - ELVIS CARDENAS ZEGARRA

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Complex icons</title>
    <style>
      html, body, #map-canvas {
        height: 100%;
        margin: 0px;
        padding: 0px
      }
    </style>
    <script src="http://maps.googleapis.com/maps/api/js?key=AIzaSyB_GD3uZWf2UtmGn79YJ3H-CmEXbFJa8D4&sensor=FALSE"></script>
    <script>
// The following example creates complex markers to indicate beaches near
// Sydney, NSW, Australia. Note that the anchor is set to
// (0,32) to correspond to the base of the flagpole.

function initialize() {
  var mapOptions = {
    zoom: 10,
    center: new google.maps.LatLng(-33.9, 151.2),
	mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  var map = new google.maps.Map(document.getElementById('map-canvas'),
                                mapOptions);

  setMarkers(map, beaches);
}

/**
 * Data for the markers consisting of a name, a LatLng and a zIndex for
 * the order in which these markers should display on top of each
 * other.
 */
var beaches = [
  ['Bondi Beach', -33.890542, 151.274856, 4],
  ['Coogee Beach', -33.923036, 151.259052, 5],
  ['Cronulla Beach', -34.028249, 151.157507, 3],
  ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
  ['Maroubra Beach', -33.950198, 151.259302, 1]
];

function setMarkers(map, locations) {
  // Add markers to the map

  // Marker sizes are expressed as a Size of X,Y
  // where the origin of the image (0,0) is located
  // in the top left of the image.

  // Origins, anchor positions and coordinates of the marker
  // increase in the X direction to the right and in
  // the Y direction down.
  var image = {
    url: 'imagenes/1.png',
    // This marker is 20 pixels wide by 32 pixels tall.
    //size: new google.maps.Size(20, 32),
    // The origin for this image is 0,0.
    origin: new google.maps.Point(0,0),
    // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  // Shapes define the clickable region of the icon.
  // The type defines an HTML &lt;area&gt; element 'poly' which
  // traces out a polygon as a series of X,Y points. The final
  // coordinate closes the poly by connecting to the first
  // coordinate.
  var shape = {
      coords: [1, 1, 1, 20, 18, 20, 18 , 1],
      type: 'poly'
  };
  for (var i = 0; i < locations.length; i++) {
    var beach = locations[i];
    var myLatLng = new google.maps.LatLng(beach[1], beach[2]);
    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        icon: image,
        shape: shape,
        title: beach[0],
        zIndex: beach[3]
    });
  }
}

google.maps.event.addDomListener(window, 'load', initialize);

    </script>
  </head>
  <body>
    <div id="map-canvas"></div>
  </body>
</html>

*/
end event

