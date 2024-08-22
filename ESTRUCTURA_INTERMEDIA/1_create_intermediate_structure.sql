/***************************************************************************
                Creación de estructura de datos intermedia
              ----------------------------------------------------------
        begin           : 2024-05-20
        git sha         : :%H$
        copyright       : (C) 2024 by Leo Cardona (CEICOL SAS)
                          (C) 2024 by Camilo Rodriguez (CEICOL SAS)        
        email           : contacto@ceicol.com
                          ccrodriguezo@ceicol.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License v3.0 as          *
 *   published by the Free Software Foundation.                            *
 *                                                                         *
 ***************************************************************************/

--====================================================
-- Creación de la extensión postgis
--====================================================
 CREATE EXTENSION IF NOT EXISTS postgis;

--====================================================
-- Inserción del sistema origen unico nacional
--====================================================
INSERT into spatial_ref_sys (
  srid, auth_name, auth_srid, proj4text, srtext
)
values
  (
    9377,
    'EPSG',
    9377,
    '+proj=tmerc +lat_0=4.0 +lon_0=-73.0 +k=0.9992 +x_0=5000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ',
    'PROJCRS["MAGNA-SIRGAS / Origen-Nacional", BASEGEOGCRS["MAGNA-SIRGAS", DATUM["Marco Geocentrico Nacional de Referencia", ELLIPSOID["GRS 1980",6378137,298.257222101, LENGTHUNIT["metre",1]]], PRIMEM["Greenwich",0, ANGLEUNIT["degree",0.0174532925199433]], ID["EPSG",4686]], CONVERSION["Colombia Transverse Mercator", METHOD["Transverse Mercator", ID["EPSG",9807]], PARAMETER["Latitude of natural origin",4, ANGLEUNIT["degree",0.0174532925199433], ID["EPSG",8801]], PARAMETER["Longitude of natural origin",-73, ANGLEUNIT["degree",0.0174532925199433], ID["EPSG",8802]], PARAMETER["Scale factor at natural origin",0.9992, SCALEUNIT["unity",1], ID["EPSG",8805]], PARAMETER["False easting",5000000, LENGTHUNIT["metre",1], ID["EPSG",8806]], PARAMETER["False northing",2000000, LENGTHUNIT["metre",1], ID["EPSG",8807]]], CS[Cartesian,2], AXIS["northing (N)",north, ORDER[1], LENGTHUNIT["metre",1]], AXIS["easting (E)",east, ORDER[2], LENGTHUNIT["metre",1]], USAGE[ SCOPE["unknown"], AREA["Colombia"], BBOX[-4.23,-84.77,15.51,-66.87]], ID["EPSG",9377]]'
  ) ON CONFLICT (srid) DO NOTHING;
  
--========================================
--Creación de esquema
--========================================
CREATE SCHEMA data_intermedia;

--========================================
--Fijar esquema
--========================================
set search_path to 
	data_intermedia,	--Nombre del esquema de estructura de datos intermedia
	public;

--=============================================
-- Área en condición de amenaza
--=============================================

CREATE TABLE area_condicion_amenaza (
	identificador varchar(50) NULL,
	fenomeno varchar(255) NOT NULL,
	categoria_amenaza varchar(255) NULL,
	priorizacion varchar(255) NULL,
	medida_intervencion varchar(255) NULL,
	detalle_medida_intervencion varchar(500) NULL,
	detalle_fenomeno varchar(500) NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Área en condición de riesgo
--=============================================
CREATE TABLE area_condicion_riesgo (
	identificador varchar(50) NULL,
	fenomeno varchar(255) NOT NULL,
	priorizacion varchar(255) NULL,
	medida_intervencion varchar(255) NULL,
	detalle_medida_intervencion varchar(500) NULL,
	detalle_fenomeno varchar(500) NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Área de actividad
--=============================================
CREATE TABLE areas_actividad (
	identificador varchar(50) NULL,
	uso_principal varchar(255) NOT NULL,
	detalle_uso_principal varchar(255) NOT NULL,
	uso_compatible_complementario varchar(500) NOT NULL,
	uso_condicionado_restringido varchar(500) NOT NULL,
	uso_prohibido varchar(500) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Centro poblado rural
--=============================================
CREATE TABLE centro_poblado_rural (
	identificador varchar(50) NULL,
	nombre varchar(255) NOT NULL,
	codigo varchar(8) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Clasificación del suelo
--=============================================
CREATE TABLE clasificacion_suelo (
	identificador varchar(50) NULL,
	tipo_clasificacion_suelo varchar(255) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Sistemas generales- Geometria poligono
--=============================================
CREATE TABLE sistemas_generales_poligono (
	identificador varchar(50) NULL,
	tipo_sistema_general varchar(255) NOT NULL,
	detalle_sistema_general varchar(255) NOT NULL,
	nivel varchar(255) NOT NULL,
	estado varchar(255) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Sistemas generales- Geometria linea
--=============================================
CREATE TABLE sistemas_generales_linea (
	identificador varchar(50) NULL,
	tipo_sistema_general varchar(255) NOT NULL,
	detalle_sistema_general varchar(255) NOT NULL,
	nivel varchar(255) NOT NULL,
	estado varchar(255) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(linestringz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Sistemas generales- Geometria punto
--=============================================
CREATE TABLE sistemas_generales_punto (
	identificador varchar(50) NULL,
	tipo_sistema_general varchar(255) NOT NULL,
	detalle_sistema_general varchar(255) NOT NULL,
	nivel varchar(255) NOT NULL,
	estado varchar(255) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(pointz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Suelo de protección urbano
--=============================================
CREATE TABLE suelo_proteccion_urbano (
	identificador varchar(50) NULL,
	uso_principal varchar(255) NOT NULL,
	detalle_uso_principal varchar(255) NOT NULL,
	uso_compatible_complementario varchar(500) NOT NULL,
	uso_condicionado_restringido varchar(500) NOT NULL,
	uso_prohibido varchar(500) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Tratamientos urbanisticos
--=============================================
CREATE TABLE tratamiento_urbanistico (
	identificador varchar(50) NULL,
	tipo_tratamiento_urbanistico varchar(255) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Zonificación de amenazas
--=============================================
CREATE TABLE zonificacion_amenaza (
	identificador varchar(50) NULL,
	fenomeno varchar(255) NOT NULL,
	categoria_amenaza varchar(50) NULL,
	descripcion varchar(255) NULL,
	detalle_fenomeno varchar(500) NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

--=============================================
-- Zonificación del suelo rural
--=============================================
CREATE TABLE zonificacion_suelo_rural (
	identificador varchar(50) NULL,
	uso_principal varchar(255) NOT NULL,
	tipo_categoria_rural varchar(255) NULL,
	detalle_uso_principal varchar(255) NOT NULL,
	uso_compatible_complementario varchar(500) NOT NULL,
	uso_condicionado_restringido varchar(500) NOT NULL,
	uso_prohibido varchar(500) NOT NULL,
	nombre varchar(255) NULL,
	descripcion_derecho varchar(255),
	descripcion_restriccion varchar(255),
	descripcion_responsabilidad varchar(255),
	area_m2 numeric(14,1) NULL,
	geometria public.geometry(multipolygonz, 9377) NULL,
	fuente_administrativa_tipo varchar(255) NOT NULL,
	fuente_administrativa_tipo_pot varchar(255) NULL,
	fuente_administrativa_estado_disponibilidad varchar(255) NOT NULL,
	fuente_administrativa_fecha_documento date NULL,
	fuente_administrativa_numero_fuente varchar(150) NULL,
	fuente_administrativa_tipo_revision varchar(255) NULL,
	fuente_espacial_tipo varchar(255) NULL,
	fuente_espacial_estado_disponibilidad varchar(255) NULL,
	fuente_espacial_metadato text NULL,
	fuente_espacial_escala numeric(12, 3) NULL,
	fuente_espacial_fecha_publicacion date NULL,
	fuente_espacial_responsable varchar(500) NULL,
	fuente_espacial_nombre varchar(255) NULL,
	fuente_espacial_fecha_documento date NULL
);

CREATE TABLE municipio (
	codigo_departamento varchar(2) NOT NULL,
	codigo_municipio varchar(3) NOT NULL,
	nombre_municipio varchar(255) NOT NULL,
	tipo_interesado varchar(255) NOT NULL,
	tipo_documento  varchar(255) NULL,
	numero_documento varchar(255) NULL
);