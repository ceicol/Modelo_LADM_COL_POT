
/***************************************************************************
                ETL estructura de datos intermedia
              ----------------------------------------------------------
        begin           : 2024-05-25
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

--========================================
--Fijar esquema
--========================================
set search_path to
	data_intermedia,	-- Esquema de estructura de datos intermedia
	ladm_pot,		-- Esquema modelo LADM-POT
	public;
	
--================================================================================
-- 1. Migración de  clasificación del suelo
--================================================================================

--1.1 Creacion de atributos temporales 
alter table pot_uab_clasificacionsuelo add id_clasificacion_suelo bigint;
alter table pot_ue_clasificacionsuelo add id_clasificacion_suelo bigint;

--1.2 diligenciamiento de la tabla  pot_uab_clasificacionsuelo
insert into pot_uab_clasificacionsuelo(
	t_basket, 
	t_ili_tid, 
	tipo_clasificacion_suelo, 
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id, 
	id_clasificacion_suelo)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from pot_clasificacionsuelotipo  where ilicode like cs.tipo_clasificacion_suelo) as tipo_clasificacion_suelo,
	cs.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_CLASIFICACIONSUELO' as espacio_de_nombres, 
	row_number() over () local_id,
	cs.id_data 
from clasificacion_suelo cs	; 

--1.3 diligenciamiento de la tabla pot_uab_clasificacionsuelo
insert into pot_ue_clasificacionsuelo(
	t_basket,
	t_ili_tid,
	relacion_superficie, 
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria,
	id_clasificacion_suelo)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_CLASIFICACIONSUELO' as  espacio_de_nombres,
	row_number () over() local_id,
	cs.geometria,
	cs.id_data 
from clasificacion_suelo cs; 


--1.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_clasificacionsuelo y pot_ue_clasificacionsuelo
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_clasificacionsuelo,
	baunit_pot_uab_clasificacionsuelo)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_clasificacionsuelo,
	uab.t_id as baunit_pot_uab_clasificacionsuelo 
from pot_uab_clasificacionsuelo uab 
join pot_ue_clasificacionsuelo ue on uab.id_clasificacion_suelo = ue.id_clasificacion_suelo;

--================================================================================
-- 2. Migración de zonificacion de amenaza
--================================================================================

--2.1 Creacion de atributos temporales 
alter table pot_uab_zonificacionamenaza  add id_zonificacion_amenaza bigint;
alter table pot_ue_zonificacionamenaza  add id_zonificacion_amenaza bigint;

--2.2 diligenciamiento de la tabla  pot_ue_zonificacionamenaza
insert into pot_uab_zonificacionamenaza(
	t_basket,
	t_ili_tid, 
	fenomeno, 
	categoria_amenaza, 
	descripcion, 
	detalle_fenomeno, 
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id,
	id_zonificacion_amenaza )
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from pot_fenomenoamenazatipo where ilicode like za.fenomeno) as fenomeno,
	(select t_id from pot_categoriaamenazatipo where ilicode like za.categoria_amenaza) as categoria_amenaza,
	za.descripcion,
	za.detalle_fenomeno,
	za.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_ZONIFICACIONAMENAZAS' as espacio_de_nombres, 
	row_number() over () local_id,
	za.id_data 
from zonificacion_amenaza as za;

--2.3 diligenciamiento de la tabla  pot_uab_zonificacionamenaza
insert into pot_ue_zonificacionamenaza (
	t_basket,
	t_ili_tid,
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_zonificacion_amenaza)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_ZONIFICACIONAMENAZAS' as  espacio_de_nombres,
	row_number () over() local_id,
	za.geometria,
	za.id_data 
from zonificacion_amenaza as za;


--2.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_zonificacionamenaza y pot_ue_zonificacionamenaza
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_zonificacionamenaza,
	baunit_pot_uab_zonificacionamenaza)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_zonificacionamenazas,
	uab.t_id as baunit_pot_uab_zonificacionamenazas
from pot_uab_zonificacionamenaza as uab 
join pot_ue_zonificacionamenaza as ue on uab.id_zonificacion_amenaza  = ue.id_zonificacion_amenaza;


--================================================================================
-- 3. Migración de área de condición de amenaza
--================================================================================

--3.1 Creacion de atributos temporales 
alter table pot_uab_areacondicionamenaza  add id_condicion_amenaza bigint;
alter table pot_ue_areacondicionamenaza add id_condicion_amenaza bigint;

--3.2 diligenciamiento de la tabla pot_uab_areacondicionamenaza
insert into pot_uab_areacondicionamenaza ( 
	t_basket, 
	t_ili_tid,
	fenomeno,
	categoria_amenaza,
	priorizacion,
	medida_intervencion,
	detalle_medida_intervencacion, 
	detalle_fenomeno, 
	nombre, 
	tipo,
	comienzo_vida_util_version, 
	espacio_de_nombres, 
	local_id, 
	id_condicion_amenaza)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from pot_fenomenoamenazatipo where ilicode like cat.fenomeno) as fenomeno,
	(select t_id from pot_categoriaamenazatipo where ilicode like cat.categoria_amenaza) as categoria_amenaza,
	(select t_id from pot_priorizaciontipo where ilicode like cat.priorizacion) as priorizacion,
	(select t_id from pot_medidaintervenciontipo where ilicode like cat.medida_intervencion) as medida_intervencion,
	cat.detalle_medida_intervencion,
	cat.detalle_fenomeno,
	cat.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_AREACONDICIONAMENAZA' as espacio_de_nombres, 
	row_number() over () local_id,
	cat.id_data
from area_condicion_amenaza as cat;


--3.3 diligenciamiento de la tabla  pot_uab_zonificacionamenazas
insert into pot_ue_areacondicionamenaza (
	t_basket,
	t_ili_tid,
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_condicion_amenaza)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_AREACONDICIONAMENAZA' as  espacio_de_nombres,
	row_number () over() local_id,
	cat.geometria,
	cat.id_data
from area_condicion_amenaza as cat;

--3.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_areacondicionamenaza y pot_ue_areacondicionamenaza
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_areacondicionamenaza,
	baunit_pot_uab_areacondicionamenaza)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_areacondicionamenaza,
	uab.t_id as baunit_pot_uab_areacondicionamenaza
from pot_uab_areacondicionamenaza uab 
join pot_ue_areacondicionamenaza ue on uab.id_condicion_amenaza  = ue.id_condicion_amenaza;

--================================================================================
-- 4. Migración de área de condición de riesgo
--================================================================================

--4.1 Creacion de atributos temporales 
alter table pot_uab_areacondicionriesgo  add id_condicion_riesgo bigint;
alter table pot_ue_areacondicionriesgo add id_condicion_riesgo bigint;

--4.2 diligenciamiento de la tabla pot_uab_areacondicionriesgo
INSERT INTO pot_uab_areacondicionriesgo( 
	t_basket, 
	t_ili_tid, 
	fenomeno, 
	priorizacion,
	medida_intervencion, 
	detalle_medida_intervencacion, 
	detalle_fenomeno, 
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id, 
	id_condicion_riesgo)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from pot_fenomenoamenazatipo where ilicode like cat.fenomeno) as fenomeno,
	(select t_id from pot_priorizaciontipo where ilicode like cat.priorizacion) as priorizacion,
	(select t_id from pot_medidaintervenciontipo where ilicode like cat.medida_intervencion) as medida_intervencion,
	cat.detalle_medida_intervencion,
	cat.detalle_fenomeno,
	cat.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_AREACONDICIONAMENAZA' as espacio_de_nombres, 
	row_number() over () local_id,
	cat.id_data
from area_condicion_riesgo cat;

--4.3 diligenciamiento de la tabla  pot_ue_areacondicionriesgo
insert into pot_ue_areacondicionriesgo  (
	t_basket,
	t_ili_tid,
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_condicion_riesgo)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_AREACONDICIONRIESGO' as  espacio_de_nombres,
	row_number () over() local_id,
	cat.geometria,
	cat.id_data
from area_condicion_riesgo cat;

--4.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_areacondicionriesgo y pot_ue_areacondicionriesgo
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_areacondicionriesgo ,
	baunit_pot_uab_areacondicionriesgo)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_areacondicionriesgo,
	uab.t_id as baunit_pot_uab_areacondicionriesgo
from pot_uab_areacondicionriesgo uab 
join pot_ue_areacondicionriesgo ue on uab.id_condicion_riesgo  = ue.id_condicion_riesgo;

--================================================================================
-- 5. Migración de zonificacion suelo rural
--================================================================================

--5.1 Creacion de atributos temporales 
alter table pot_uab_zonificacionsuelorural add id_zonificacion_rural bigint;
alter table pot_ue_zonificacionsuelorural add id_zonificacion_rural bigint;

--5.2 diligenciamiento de la tabla pot_uab_zonificacionsuelorural
insert into pot_uab_zonificacionsuelorural (
	t_basket, 
	t_ili_tid, 
	uso_principal,
	tipo_categoria_rural,
	detalle_uso_principal, 
	clasificacion_suelo_rural, 
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id,
	id_zonificacion_rural)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from pot_usosueloruraltipo where ilicode like zsr.uso_principal) as uso_principal,
	(select t_id from pot_categoriaruraltipo where ilicode like zsr.tipo_categoria_rural) as tipo_categoria_rural,
	zsr.detalle_uso_principal  as detalle_uso_principal,
	(select t_id from pot_uab_clasificacionsuelo  cs where cs.tipo_clasificacion_suelo in
		(select t_id from pot_clasificacionsuelotipo where ilicode like 'Rural') limit 1) as clasificacion_suelo_rural,
	zsr.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_ZONIFICACIONSUELORURAL' as  espacio_de_nombres,
	row_number () over() local_id,
	zsr.id_data
from zonificacion_suelo_rural zsr;

--5.3 diligenciamiento de la tabla pot_ue_zonificacionsuelorural
insert into pot_ue_zonificacionsuelorural(
	t_basket,
	t_ili_tid,
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_zonificacion_rural)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_ZONIFICACIONSUELORURAL' as  espacio_de_nombres,
	row_number () over() local_id,
	zsr.geometria,
	zsr.id_data
from zonificacion_suelo_rural zsr;

--5.4 Diligenciamiento estructuras
--5.4.1 pot_usocompatiblecomplementariovalor
insert into pot_usocompatiblecomplementariovalor(
	t_basket, 
	t_ili_tid,
	valor, 
	pot_uab_zonifccnslrral_uso_compatible_complementario)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	zr.uso_compatible_complementario as valor,
	puz.t_id 
from pot_uab_zonificacionsuelorural puz
join zonificacion_suelo_rural zr on zr.id_data =puz.id_zonificacion_rural ;

--5.4.2 pot_usocondicionadorestringidovalor
insert into pot_usocondicionadorestringidovalor(
	t_basket, 
	t_ili_tid,
	valor,
	pot_uab_zonifccnslrral_uso_condicionado_restringido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	zr.uso_condicionado_restringido as valor,
	puz.t_id 
from pot_uab_zonificacionsuelorural puz
join zonificacion_suelo_rural zr on zr.id_data =puz.id_zonificacion_rural ;


--5.4.3 pot_usoprohibidovalor
insert into pot_usoprohibidovalor(
	t_basket, 
	t_ili_tid,  
	valor,
	pot_uab_zonifccnslrral_uso_prohibido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	zr.uso_condicionado_restringido as valor,
	puz.t_id 
from pot_uab_zonificacionsuelorural puz
join zonificacion_suelo_rural zr on zr.id_data =puz.id_zonificacion_rural ;

--5.5 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
--pot_uab_zonificacionsuelorural y pot_ue_zonificacionsuelorural
insert into col_uebaunit ( 
	t_basket,
	baunit_pot_uab_zonificacionsuelorural,
	ue_pot_ue_zonificacionsuelorural)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uab.t_id as baunit_pot_uab_zonificacionsuelorural,
	ue.t_id as ue_pot_ue_zonificacionsuelorural
from pot_uab_zonificacionsuelorural uab 
join pot_ue_zonificacionsuelorural ue on uab.id_zonificacion_rural = ue.id_zonificacion_rural;

--================================================================================
-- 6. Migración de tratamientos urbanisticos
--================================================================================

-- 6.1 Creacion de atributos temporales 
alter table pot_uab_tratamientourbanistico add id_tratamientos_urbanisticos bigint;
alter table pot_ue_tratamientourbanistico add id_tratamientos_urbanisticos bigint;

-- 6.2 diligenciamiento de la tabla pot_uab_tratamientourbanistico
insert into pot_uab_tratamientourbanistico(
	t_basket, 
	t_ili_tid,
	nombre,
	tipo_tratamiento_urbanistico, 
	tipo, 
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	id_tratamientos_urbanisticos)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	tu.nombre,
	(select t_id from pot_tratamientourbanisticotipo where ilicode like tu.tipo_tratamiento_urbanistico) as tipo_tratamiento_urbanistico,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_TRATAMIENTOURBANISTICO' as  espacio_de_nombres,
	row_number () over() local_id,
	tu.id_data
from tratamiento_urbanistico tu;

-- 6.3 diligenciamiento de la tabla pot_ue_tratamientourbanistico 
insert into pot_ue_tratamientourbanistico (
	t_basket,
	t_ili_tid, 
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_tratamientos_urbanisticos)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_TRATAMIENTOURBANISTICO' as  espacio_de_nombres,
	row_number () over() local_id,
	tu.geometria,
	tu.id_data
from tratamiento_urbanistico tu;

-- 6.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_tratamientourbanistico y pot_ue_tratamientourbanistico
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_tratamientourbanistico,
	baunit_pot_uab_tratamientourbanistico)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_tratamientourbanistico,
	uab.t_id as baunit_pot_uab_tratamientourbanistico
from pot_uab_tratamientourbanistico uab 
join pot_ue_tratamientourbanistico  ue on uab.id_tratamientos_urbanisticos = ue.id_tratamientos_urbanisticos ;

--================================================================================
-- 7. Migración de areas de actividad
--================================================================================

-- 7.1 Creacion de atributos temporales 
alter table pot_uab_centropobladorural add id_centro_poblado bigint;
alter table pot_ue_centropobladorural  add id_centro_poblado bigint;

-- 7.2 diligenciamiento de la tabla pot_uab_centropobladorural
insert into pot_uab_centropobladorural(
	t_basket, 
	t_ili_tid, 
	nombre,
	codigo, 
	clasificacion_suelo, 
	pot_desarrollo_restringido, 
	tipo, 
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id,
	id_centro_poblado)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	cr.nombre,
	cr.codigo,
	(select t_id from pot_uab_clasificacionsuelo  cs where cs.tipo_clasificacion_suelo in
		(select t_id from pot_clasificacionsuelotipo where ilicode like 'Rural') limit 1) as clasificacion_suelo_rural,
	puz.t_id as pot_desarrollo_restringido,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_CENTROPOBLADORURAL' as  espacio_de_nombres,
	row_number () over() local_id,
	cr.id_data
from centro_poblado_rural as cr
join zonificacion_suelo_rural as sr on ST_equals(cr.geometria,sr.geometria)
join pot_uab_zonificacionsuelorural puz on sr.id_data = puz.id_zonificacion_rural
where puz.uso_principal in (select t_id from pot_usosueloruraltipo where ilicode like 'Centro_Poblado');

-- 7.3 diligenciamiento de la tabla pot_ue_centropobladorural
insert into pot_ue_centropobladorural (
	t_basket, 
	t_ili_tid, 
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id,
	geometria,
	id_centro_poblado)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4(),
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'CENTROPOBLADORURAL' as  espacio_de_nombres,
	row_number () over() local_id,
	cr.geometria,
	cr.id_data
from centro_poblado_rural as cr;

-- 7.4 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_centropobladorural y pot_ue_centropobladorural
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_centropobladorural,
	baunit_pot_uab_centropobladorural)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_centropobladorural,
	uab.t_id as baunit_pot_uab_centropobladorural
from pot_uab_centropobladorural uab 
join pot_ue_centropobladorural ue on uab.id_centro_poblado = ue.id_centro_poblado ;

--================================================================================
-- 8. Migración de areas de actividad
--================================================================================

-- 8.1 Creacion de atributos temporales 
alter table pot_uab_areasactividad  add id_areas_actividad bigint;
alter table pot_ue_areasactividad  add id_areas_actividad bigint;

-- 8.2 diligenciamiento de la tabla pot_uab_areasactividad
insert into pot_uab_areasactividad(
	t_basket,
	t_ili_tid, 
	uso_principal, 
	detalle_uso_principal,
	centro_poblado,
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id, 
	id_areas_actividad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from pot_areaactividadtipo where ilicode like aa.uso_principal) as uso_principal,
	aa.detalle_uso_principal as detalle_uso_principal,
	(select t_id from pot_uab_centropobladorural where id_centro_poblado in (select id_data from centro_poblado_rural as cr
		where st_contains(cr.geometria,aa.geometria))) as centro_poblado,
	aa.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_AREASACTIVIDAD' as  espacio_de_nombres,
	row_number () over() local_id,
	aa.id_data
from areas_actividad aa;

-- 8.3 diligenciamiento de la tabla pot_ue_areasactividad
insert into pot_ue_areasactividad (
	t_basket,
	t_ili_tid, 
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_areas_actividad)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_AREASACTIVIDAD' as  espacio_de_nombres,
	row_number () over() local_id,
	aa.geometria,
	aa.id_data
from areas_actividad aa;

--8.4 Diligenciamiento estructuras
--8.4.1 pot_usocompatiblecomplementariovalor
insert into pot_usocompatiblecomplementariovalor(
	t_basket,
	t_ili_tid,
	valor, 
	pot_uab_areasactividad_uso_compatible_complementario)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_compatible_complementario  as valor,
	pua.t_id 
from pot_uab_areasactividad pua
join areas_actividad aa on pua.id_areas_actividad = aa.id_data;

--8.4.2 pot_usocondicionadorestringidovalor
insert into pot_usocondicionadorestringidovalor(
	t_basket, 
	t_ili_tid,  
	valor, 
	pot_uab_areasactividad_uso_condicionado_restringido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_condicionado_restringido as valor,
	pua.t_id 
from pot_uab_areasactividad pua
join areas_actividad aa on pua.id_areas_actividad = aa.id_data;

--8.4.3 pot_usoprohibidovalor
insert into pot_usoprohibidovalor(
	t_basket, 
	t_ili_tid,  
	valor,
	pot_uab_areasactividad_uso_prohibido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_prohibido  as valor,
	pua.t_id 
from pot_uab_areasactividad pua
join areas_actividad aa on pua.id_areas_actividad = aa.id_data;


--8.5 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_areasactividad y pot_ue_areasactividad
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_areasactividad,
	baunit_pot_uab_areasactividad)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_areasactividad,
	uab.t_id as baunit_pot_uab_areasactividad
from pot_uab_areasactividad uab 
join pot_ue_areasactividad ue on uab.id_areas_actividad = ue.id_areas_actividad;

--================================================================================
-- 9. Migración de sistemas generales
--================================================================================

--9.1 Creacion de atributos temporales 
alter table pot_uab_sistemasgenerales  add id_sistema_general bigint;
alter table pot_ue_sistemasgenerales  add id_sistema_general bigint;

--9.2 diligenciamiento de la tabla pot_uab_sistemasgenerales
insert into pot_uab_sistemasgenerales(
	t_basket, 
	t_ili_tid,
	tipo_sistema_general, 
	detalle_sistema_general, 
	nivel, 
	estado, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres,
	local_id, 
	id_sistema_general)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from pot_sistemasgeneralestipo where ilicode like sgt.tipo_sistema_general) as tipo_sistema_general,
	sgt.detalle_sistema_general as  detalle_sistema_general,
	(select t_id from pot_sistemasgeneralesniveltipo where ilicode like sgt.nivel) as nivel,
	(select t_id from pot_sistemasgeneralesestadotipo where ilicode like sgt.estado) as estado,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_SISTEMASGENERALES' as  espacio_de_nombres,
	row_number () over() local_id,
	sgt.id_data
from sistemas_generales sgt;


--9.3 diligenciamiento de tabla pot_ue_sistemasgenerales 
insert into pot_ue_sistemasgenerales(
	t_basket,
	t_ili_tid,
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria,
	id_sistema_general)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_SISTEMASGENERALES' as  espacio_de_nombres,
	row_number () over() local_id,
	case 
		when st_geometrytype(sgt.geometria) = 'ST_MultiPolygon' then sgt.geometria 
		else null
	end as geometria,
	sgt.id_data
from sistemas_generales sgt;

--9.4 vincular las geometrias de tipo linea al sistema general
insert into pot_referencialineasistemasgenerales(
	t_basket, 
	t_ili_tid, 
	geometria, 
	sistemasgenerales)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	sgt.geometria,
	ue.t_id
from sistemas_generales sgt
join pot_ue_sistemasgenerales ue on ue.id_sistema_general= sgt.id_data
where st_geometrytype(sgt.geometria) = 'ST_LineString';

--9.5 vincular las geometrias de tipo punto al sistema general
insert into pot_referenciapuntosistemasgenerales(
	t_basket, 
	t_ili_tid,
	geometria,
	sistemagenerales)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	sgt.geometria,
	ue.t_id
from sistemas_generales sgt
join pot_ue_sistemasgenerales ue on ue.id_sistema_general= sgt.id_data
where st_geometrytype(sgt.geometria) = 'ST_Point';


--9.6 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
--pot_ue_sistemasgenerales y pot_uab_sistemasgenerales
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_sistemasgenerales,
	baunit_pot_uab_sistemasgenerales)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_sistemasgenerales,
	uab.t_id as baunit_pot_uab_sistemasgenerales
from pot_uab_sistemasgenerales uab 
join pot_ue_sistemasgenerales ue on uab.id_sistema_general = ue.id_sistema_general;


--================================================================================
-- 10. Migración de suelo de protección urbano
--================================================================================

-- 10.1 Creacion de atributos temporales 
alter table pot_uab_sueloproteccionurbano  add id_suelo_proteccion_urbano bigint;
alter table pot_ue_sueloproteccionurbano add id_suelo_proteccion_urbano bigint;

-- 10.2 diligenciamiento de la tabla pot_uab_sueloproteccionurbano
insert into pot_uab_sueloproteccionurbano(
	t_basket,
	t_ili_tid, 
	uso_principal, 
	detalle_uso_principal,
	nombre, 
	tipo, 
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id, 
	id_suelo_proteccion_urbano)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from pot_sueloproteccionurbanotipo where ilicode like sp.uso_principal) as uso_principal,
	sp.detalle_uso_principal as detalle_uso_principal,
	sp.nombre,
	(select t_id from col_unidadadministrativabasicatipo where ilicode like 'Vivienda_Ciudad_Territorio') as tipo,
	now() as comienzo_vida_util_version,
	'POT_UAB_SUELOPROTECCIONTIPO' as  espacio_de_nombres,
	row_number () over() local_id,
	sp.id_data
from suelo_proteccion_urbano as sp;

-- 10.3 diligenciamiento de la tabla pot_ue_sueloproteccionurbano 
insert into pot_ue_sueloproteccionurbano (
	t_basket,
	t_ili_tid, 
	relacion_superficie,  
	comienzo_vida_util_version, 
	espacio_de_nombres,
	local_id, 
	geometria, 
	id_suelo_proteccion_urbano)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from col_relacionsuperficietipo where ilicode like 'En_Rasante') as relacion_superficie,
	now() as comienzo_vida_util_version,
	'POT_UE_SUELOPROTECCIONTIPO' as  espacio_de_nombres,
	row_number () over() local_id,
	sp.geometria,
	sp.id_data
from suelo_proteccion_urbano as sp;


--10.4 Diligenciamiento estructuras
--10.4.1 pot_usocompatiblecomplementariovalor
insert into pot_usocompatiblecomplementariovalor(
	t_basket,
	t_ili_tid,
	valor, 
	pot_uab_sulprtccnrbano_uso_compatible_complementario)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_compatible_complementario  as valor,
	pua.t_id 
from pot_uab_sueloproteccionurbano pua
join suelo_proteccion_urbano aa on pua.id_suelo_proteccion_urbano = aa.id_data;

--10.4.2 pot_usocondicionadorestringidovalor
insert into pot_usocondicionadorestringidovalor(
	t_basket, 
	t_ili_tid,  
	valor, 
	pot_uab_sulprtccnrbano_uso_condicionado_restringido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_condicionado_restringido as valor,
	pua.t_id 
from pot_uab_sueloproteccionurbano pua
join suelo_proteccion_urbano aa on pua.id_suelo_proteccion_urbano = aa.id_data;

--10.4.3 pot_usoprohibidovalor
insert into pot_usoprohibidovalor(
	t_basket, 
	t_ili_tid,  
	valor,
	pot_uab_sulprtccnrbano_uso_prohibido)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	aa.uso_prohibido  as valor,
	pua.t_id 
from pot_uab_sueloproteccionurbano pua
join suelo_proteccion_urbano aa on pua.id_suelo_proteccion_urbano = aa.id_data;


--10.5 diligenciamiento de la tabla col_uebaunit la cual relaciona las tablas
-- pot_uab_sueloproteccionurbano y  pot_ue_sueloproteccionurbano 
insert into col_uebaunit( 
	t_basket,	
	ue_pot_ue_sueloproteccionurbano,
	baunit_pot_uab_sueloproteccionurbano)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	ue.t_id as ue_pot_ue_sueloproteccionurbano,
	uab.t_id as baunit_pot_uab_sueloproteccionurbano
from pot_uab_sueloproteccionurbano uab 
join pot_ue_sueloproteccionurbano  ue on uab.id_suelo_proteccion_urbano = ue.id_suelo_proteccion_urbano;


--================================================================================
--Migración de interesados pot_municipio 
--================================================================================
insert into pot_municipio (
	t_basket, 
	t_ili_tid, 
	codigo_departamento, 
	codigo_municipio, 
	nombre_municipio,
	tipo_interesado,
	tipo_documento,
	numero_documento, 
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	pm.codigo_departamento,
	pm.codigo_municipio,
	pm.nombre_municipio,
	(select t_id from col_interesadotipo where ilicode like pm.tipo_interesado) as tipo_interesado,
	(select t_id from col_documentotipo where ilicode like pm.tipo_documento) as tipo_documento,
	pm.numero_documento,
	now() as comienzo_vida_util_version,
	'POT_MUNICIPIO' as  espacio_de_nombres,
	row_number () over() local_id
from municipio as pm ;


--================================================================================
--Migración pot_fuenteadministrativa
--================================================================================

--================================================================================
--Creacion de tabla temporal de las fuentes administrativas
--================================================================================
create table fuentes_administrativas as 
select *, row_number() over() id_data from (
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision from area_condicion_amenaza
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision from area_condicion_riesgo
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from areas_actividad
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from centro_poblado_rural
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from clasificacion_suelo
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from sistemas_generales
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from suelo_proteccion_urbano
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from tratamiento_urbanistico
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from zonificacion_amenaza
union
select distinct fuente_administrativa_tipo, fuente_administrativa_tipo_pot,fuente_administrativa_estado_disponibilidad,  fuente_administrativa_fecha_documento, fuente_administrativa_numero_fuente,fuente_administrativa_tipo_revision  from zonificacion_suelo_rural);

--11.1 Creacion de atributos temporales 
alter table pot_fuenteadministrativa  add id_fuente bigint;
--11.2 diligenciamiento de la tabla 
insert into pot_fuenteadministrativa (
	t_basket,
	t_ili_tid,
	tipo, 
	tipo_pot,
	estado_disponibilidad,
	tipo_revision,
	numero_fuente,
	fecha_documento_fuente,
	espacio_de_nombres, 
	local_id,
	id_fuente)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	(select t_id from col_fuenteadministrativatipo where ilicode like  fuente_administrativa_tipo and thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo') as fuente_administrativa_tipo,
	(select t_id from pot_planordenamientoterritorialtipo where ilicode like fuente_administrativa_tipo_pot) as fuente_administrativa_tipo_pot,
	(select t_id from col_estadodisponibilidadtipo where ilicode like fuente_administrativa_estado_disponibilidad) as fuente_administrativaa_estado_disponibilidad,
	(select t_id from pot_revisiontipo where ilicode like fuente_administrativa_tipo_revision) as fuente_administrativa_tipo_revision,
	fuente_administrativa_numero_fuente,
	fuente_administrativa_fecha_documento,
	'POT_FUENTEADMINISTRATIVA',
	row_number() over() local_id,
	id_data
from fuentes_administrativas;

--================================================================================
-- Registro de las RRR
--================================================================================
--==========================================================
-- Unidad administrativa basica pot_uab_clasificacionsuelo
--==========================================================

-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_clasificacionsuelo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_clasificacionsuelo,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_clasificacionsuelo as uab
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_clasificacionsuelo as uab on dr.unidad_pot_uab_clasificacionsuelo = uab.t_id
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_clasificacionsuelo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_clasificacionsuelo,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_clasificacionsuelo as uab
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_clasificacionsuelo as uab on dr.unidad_pot_uab_clasificacionsuelo = uab.t_id
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_clasificacionsuelo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_clasificacionsuelo,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_clasificacionsuelo as uab
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_clasificacionsuelo as uab on dr.unidad_pot_uab_clasificacionsuelo = uab.t_id
join clasificacion_suelo  as dt on uab.id_clasificacion_suelo = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_tratamientourbanistico 
--==========================================================

-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_tratamientourbanistico,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_tratamientourbanistico,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_tratamientourbanistico uab
join tratamiento_urbanistico  as dt on uab.id_tratamientos_urbanisticos = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_tratamientourbanistico as uab on dr.unidad_pot_uab_tratamientourbanistico = uab.t_id
join tratamiento_urbanistico as dt on uab.id_tratamientos_urbanisticos = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_tratamientourbanistico,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_tratamientourbanistico,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_tratamientourbanistico uab
join tratamiento_urbanistico  as dt on uab.id_tratamientos_urbanisticos = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_tratamientourbanistico as uab on dr.unidad_pot_uab_tratamientourbanistico = uab.t_id
join tratamiento_urbanistico as dt on uab.id_tratamientos_urbanisticos = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_tratamientourbanistico,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_tratramientourbanistico,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_tratamientourbanistico uab
join tratamiento_urbanistico  as dt on uab.id_tratamientos_urbanisticos = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_tratamientourbanistico as uab on dr.unidad_pot_uab_tratamientourbanistico = uab.t_id
join tratamiento_urbanistico as dt on uab.id_tratamientos_urbanisticos = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_areasactivdad
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areasactividad,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areasactividad,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areasactividad uab
join areas_actividad  as dt on uab.id_areas_actividad = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_areasactividad as uab on dr.unidad_pot_uab_areasactividad = uab.t_id
join areas_actividad as dt on uab.id_areas_actividad  = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areasactividad ,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_uab_areasactividad,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areasactividad uab
join areas_actividad  as dt on uab.id_areas_actividad = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_areasactividad as uab on dr.unidad_pot_uab_areasactividad = uab.t_id
join areas_actividad as dt on uab.id_areas_actividad  = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areasactividad ,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areasactividad,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areasactividad uab
join areas_actividad  as dt on uab.id_areas_actividad = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_areasactividad as uab on dr.unidad_pot_uab_areasactividad = uab.t_id
join areas_actividad as dt on uab.id_areas_actividad  = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_zonificacionsuelorural
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionsuelorural,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonificacionsuelorural,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionsuelorural uab
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_zonificacionsuelorural as uab on dr.unidad_pot_uab_zonificacionsuelorural = uab.t_id
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionsuelorural,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonificacionsuelorural,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionsuelorural uab
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_zonificacionsuelorural as uab on dr.unidad_pot_uab_zonificacionsuelorural = uab.t_id
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionsuelorural ,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonificacionsuelorural,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionsuelorural uab
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_zonificacionsuelorural as uab on dr.unidad_pot_uab_zonificacionsuelorural = uab.t_id
join zonificacion_suelo_rural  as dt on uab.id_zonificacion_rural = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_sistemasgenerales
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sistemasgenerales,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_sistemasgenerales,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sistemasgenerales uab
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_sistemasgenerales as uab on dr.unidad_pot_uab_sistemasgenerales = uab.t_id
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sistemasgenerales,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_sistemasgenerales,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sistemasgenerales uab
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_sistemasgenerales as uab on dr.unidad_pot_uab_sistemasgenerales = uab.t_id
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sistemasgenerales,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_sistemasgenerales,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sistemasgenerales uab
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_sistemasgenerales as uab on dr.unidad_pot_uab_sistemasgenerales = uab.t_id
join sistemas_generales  as dt on uab.id_sistema_general = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_centropobladorural
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_centropobladorural,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_centropobladorural,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_centropobladorural uab
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_centropobladorural as uab on dr.unidad_pot_uab_centropobladorural = uab.t_id
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_centropobladorural,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_centropobladorural,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_centropobladorural uab
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_centropobladorural as uab on dr.unidad_pot_uab_centropobladorural = uab.t_id
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_centropobladorural,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_centropobladorural,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_centropobladorural uab
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_centropobladorural as uab on dr.unidad_pot_uab_centropobladorural = uab.t_id
join centro_poblado_rural  as dt on uab.id_centro_poblado = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--==========================================================
-- Unidad administrativa basica pot_uab_areacondicionriesgo
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionriesgo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionriesgo,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionriesgo uab
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_areacondicionriesgo  as uab on dr.unidad_pot_uab_areacondicionriesgo = uab.t_id
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionriesgo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionriesgo,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionriesgo uab
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_areacondicionriesgo  as uab on dr.unidad_pot_uab_areacondicionriesgo = uab.t_id
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionriesgo,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionriesgo,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionriesgo uab
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_areacondicionriesgo  as uab on dr.unidad_pot_uab_areacondicionriesgo = uab.t_id
join area_condicion_riesgo  as dt on uab.id_condicion_riesgo= dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;


--==========================================================
-- Unidad administrativa basica pot_uab_areacondicionamenaza
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionamenaza,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionamenaza uab
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_areacondicionamenaza as uab on dr.unidad_pot_uab_areacondicionamenaza = uab.t_id
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionamenaza,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionamenaza uab
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_areacondicionamenaza as uab on dr.unidad_pot_uab_areacondicionamenaza = uab.t_id
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_areacondicionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_areacondicionamenaza,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_areacondicionamenaza uab
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_areacondicionamenaza as uab on dr.unidad_pot_uab_areacondicionamenaza = uab.t_id
join area_condicion_amenaza  as dt on uab.id_condicion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;


--==========================================================
-- Unidad administrativa basica pot_uab_zonificacionamenaza
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonificacionamenaza,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionamenaza uab
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_zonificacionamenaza as uab on dr.unidad_pot_uab_zonificacionamenaza = uab.t_id
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonificacionamenaza,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionamenaza uab
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_zonificacionamenaza as uab on dr.unidad_pot_uab_zonificacionamenaza = uab.t_id
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_zonificacionamenaza,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonficacionamenaza,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_zonificacionamenaza uab
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_zonificacionamenaza as uab on dr.unidad_pot_uab_zonificacionamenaza = uab.t_id
join zonificacion_amenaza  as dt on uab.id_zonificacion_amenaza = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;


--==========================================================
-- Unidad administrativa basica pot_uab_sueloproteccionurbano
--==========================================================
-- Derechos
insert into pot_derecho(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sueloproteccionurbano,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_derecho,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_sueloproteccionurbano,
	now() comienzo_vida_util_version,
	'POT_DERECHO' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sueloproteccionurbano uab
join suelo_proteccion_urbano as dt  on uab.id_suelo_proteccion_urbano  = dt.id_data
where dt.descripcion_derecho is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_derecho)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_derecho
from pot_derecho as dr
join pot_uab_sueloproteccionurbano as uab on dr.unidad_pot_uab_sueloproteccionurbano = uab.t_id
join suelo_proteccion_urbano  as dt on uab.id_suelo_proteccion_urbano = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

-- Restriccion
insert into pot_restriccion(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sueloproteccionurbano,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_restriccion,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_sueloproteccionurbano,
	now() comienzo_vida_util_version,
	'POT_RESTRICCION' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sueloproteccionurbano uab
join suelo_proteccion_urbano as dt  on uab.id_suelo_proteccion_urbano  = dt.id_data
where dt.descripcion_restriccion is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_restriccion)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_restriccion
from pot_restriccion as dr
join pot_uab_sueloproteccionurbano as uab on dr.unidad_pot_uab_sueloproteccionurbano = uab.t_id
join suelo_proteccion_urbano  as dt on uab.id_suelo_proteccion_urbano = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce(dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;

--Responsabilidad
insert into pot_responsabilidad(
	t_basket, 
	t_ili_tid,  
	descripcion,
	interesado_pot_municipio,
	unidad_pot_uab_sueloproteccionurbano,
	comienzo_vida_util_version,
	espacio_de_nombres, 
	local_id)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	dt.descripcion_responsabilidad,
	(select t_id from pot_municipio limit 1) as interesado_pot_municipio,
	uab.t_id  as unidad_pot_uab_zonficacionamenaza,
	now() comienzo_vida_util_version,
	'POT_RESPONSABILIDAD' as espacio_de_nombres,
	row_number() over() local_id 
from pot_uab_sueloproteccionurbano uab
join suelo_proteccion_urbano as dt  on uab.id_suelo_proteccion_urbano  = dt.id_data
where dt.descripcion_responsabilidad is not null;

--Tabla de paso col_rrrfuente
insert into col_rrrfuente(
	t_basket,
	fuente_administrativa,
	rrr_pot_responsabilidad)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pf.t_id fuente_administrativa,
	dr.t_id rrr_pot_responsabilidad
from pot_responsabilidad as dr
join pot_uab_sueloproteccionurbano as uab on dr.unidad_pot_uab_sueloproteccionurbano = uab.t_id
join suelo_proteccion_urbano  as dt on uab.id_suelo_proteccion_urbano = dt.id_data
join fuentes_administrativas as ft on ft.fuente_administrativa_tipo = dt.fuente_administrativa_tipo 
	and ft.fuente_administrativa_estado_disponibilidad = dt.fuente_administrativa_estado_disponibilidad 
    and coalesce(ft.fuente_administrativa_tipo_pot,'NULL') = coalesce(dt.fuente_administrativa_tipo_pot,'NULL')
	and (ft.fuente_administrativa_fecha_documento = dt.fuente_administrativa_fecha_documento or 
		(ft.fuente_administrativa_fecha_documento is null and dt.fuente_administrativa_fecha_documento is null))
	and coalesce(ft.fuente_administrativa_numero_fuente,'NULL') = coalesce(dt.fuente_administrativa_numero_fuente,'NULL')
	and coalesce(ft.fuente_administrativa_tipo_revision,'NULL') = coalesce (dt.fuente_administrativa_tipo_revision,'NULL')
join pot_fuenteadministrativa as pf on pf.id_fuente = ft.id_data;


--================================================================================
--Limpieza de vértices duplicados 
--================================================================================

--pot_ue_clasificacionsuelo
update pot_ue_clasificacionsuelo set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true=true;

--pot_ue_tratamientourbanistico
update pot_ue_tratamientourbanistico set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true=true;

--pot_ue_sueloproteccionurbano
update pot_ue_sueloproteccionurbano set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true=true;

--pot_ue_sistemasgenerales
update pot_ue_sistemasgenerales set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where geometria is not null;

--pot_ue_zonificacionsuelorural
update pot_ue_zonificacionsuelorural set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--pot_ue_areacondicionamenaza
update pot_ue_areacondicionamenaza set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--pot_ue_areacondicionriesgo
update pot_ue_areacondicionriesgo set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--pot_ue_areacondicionriesgo
update pot_ue_areasactividad set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--pot_ue_zonificacionamenaza 
update pot_ue_zonificacionamenaza set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--pot_ue_centropobladorural
update pot_ue_centropobladorural set 
	geometria =st_removerepeatedpoints(geometria,0.01)
where true = true;

--================================================================================
--Creacion de tabla temporal de las fuentes espaciales
--================================================================================
create table fuentes_espaciales as 
select *, row_number() over() id_data from (
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento from area_condicion_amenaza
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento from area_condicion_riesgo
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from areas_actividad
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from centro_poblado_rural
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from clasificacion_suelo
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from sistemas_generales
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from suelo_proteccion_urbano
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from tratamiento_urbanistico
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from zonificacion_amenaza
union
select distinct fuente_espacial_tipo, fuente_espacial_estado_disponibilidad, fuente_espacial_metadato,fuente_espacial_escala, fuente_espacial_fecha_publicacion, fuente_espacial_responsable, fuente_espacial_nombre, fuente_espacial_fecha_documento  from zonificacion_suelo_rural);

--Eliminar registros nulos de la tabla fuentes_espaciales
delete from fuentes_espaciales
where fuente_espacial_tipo is null
  and fuente_espacial_estado_disponibilidad is null
  and fuente_espacial_metadato is null
  and fuente_espacial_escala is null
  and fuente_espacial_fecha_publicacion is null
  and fuente_espacial_responsable is null
  and fuente_espacial_nombre is null
  and fuente_espacial_fecha_documento is null;

--13.1 Creacion de atributos temporales 
alter table pot_fuenteespacial add id_fuente bigint;

--13.2 diligenciamiento de la tabla 
INSERT INTO pot_fuenteespacial (
	t_basket, 
	t_ili_tid, 
	escala, 
	fecha_publicacion,
	responsable, 
	tipo, 
	metadato, 
	estado_disponibilidad, 
	fecha_documento_fuente, 
	nombre, 
	espacio_de_nombres, 
	local_id,
	id_fuente)
select 
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	uuid_generate_v4() as t_ili_tid,
	fe.fuente_espacial_escala as escala,
	fe.fuente_espacial_fecha_publicacion as fecha_publicacion,
	fe.fuente_espacial_responsable as responsable,
	(select t_id from col_fuenteespacialtipo where ilicode like fe.fuente_espacial_tipo) as fuente_espacial_tipo,
	fe.fuente_espacial_metadato as metadato,
	(select t_id from col_estadodisponibilidadtipo where ilicode like fe.fuente_espacial_estado_disponibilidad) as estado_disponibilidad,
	fe.fuente_espacial_fecha_documento as fuente_documento,
	fe.fuente_espacial_nombre as nombres,
	'POT_FUENTEESPACIAL' as espacio_nombres,
	row_number() over() local_id,
	id_data
from fuentes_espaciales as fe ;

--==================================================================================
-- 14. Tabla de paso col_ueFuente (Relación de fuente espacial y unidad espacial)
--==================================================================================

--14.1 Unidad administrativa basica pot_ue_areacondicionamenaza 
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_areacondicionamenaza,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_areacondicionamenaza as pua 
join area_condicion_amenaza as dt on pua.id_condicion_amenaza = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.2 Unidad administrativa basica pot_ue_areacondicionriesgo
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_areacondicionriesgo,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_areacondicionriesgo as pua 
join area_condicion_riesgo as dt on pua.id_condicion_riesgo = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.3  Unidad administrativa basica pot_ue_areaactividad
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_areasactividad,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_areasactividad as pua 
join areas_actividad as dt on pua.id_areas_actividad = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.4  Unidad administrativa basica pot_ue_centropobladorural
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_centropobladorural,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_centropobladorural as pua 
join centro_poblado_rural as dt on pua.id_centro_poblado = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.5  Unidad administrativa basica pot_ue_clasificacionsuelo
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_clasificacionsuelo,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_clasificacionsuelo as pua 
join clasificacion_suelo as dt on pua.id_clasificacion_suelo = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.6  Unidad administrativa basica pot_ue_sistemasgenerales
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_sistemasgenerales,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_sistemasgenerales as pua 
join sistemas_generales as dt on pua.id_sistema_general = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.7  Unidad administrativa basica pot_ue_tratamientourbanistico 
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_tratamientourbanistico,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_tratamientourbanistico as pua 
join tratamiento_urbanistico as dt on pua.id_tratamientos_urbanisticos = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.8  Unidad administrativa basica pot_ue_zonificacionamenaza
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_zonificacionamenaza,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_zonificacionamenaza as pua 
join zonificacion_amenaza as dt on pua.id_zonificacion_amenaza = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.9  Unidad administrativa basica pot_ue_zonificacionsuelorural
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_zonificacionsuelorural,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_zonificacionsuelorural as pua 
join zonificacion_suelo_rural as dt on pua.id_zonificacion_rural = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

--14.10  Unidad administrativa basica pot_ue_sueloproteccionurbano
insert into col_uefuente ( 
	t_basket,
	ue_pot_ue_sueloproteccionurbano,
	fuente_espacial)
select
	(select t_id from t_ili2db_basket where topic like 'LADM_COL_v_2_0_0_Ext_POT.Planes_Ordenamiento_Territorial' limit 1) as t_basket,
	pua.t_id,
	pf.t_id	
from pot_ue_sueloproteccionurbano as pua 
join suelo_proteccion_urbano as dt on pua.id_suelo_proteccion_urbano = dt.id_data
join fuentes_espaciales fe on fe.fuente_espacial_tipo = dt.fuente_espacial_tipo
	and fe.fuente_espacial_estado_disponibilidad = dt.fuente_espacial_estado_disponibilidad 
	and coalesce(fe.fuente_espacial_metadato,'NULL') = coalesce(dt.fuente_espacial_metadato,'NULL')
	and (fe.fuente_espacial_escala = dt.fuente_espacial_escala or (fe.fuente_espacial_escala is null and dt.fuente_espacial_escala is null))
	and (fe.fuente_espacial_fecha_publicacion = dt.fuente_espacial_fecha_publicacion  or (fe.fuente_espacial_fecha_publicacion is null and dt.fuente_espacial_fecha_publicacion is null))
	and (fe.fuente_espacial_responsable = dt.fuente_espacial_responsable or (fe.fuente_espacial_responsable is null and dt.fuente_espacial_responsable is null))
	and (fe.fuente_espacial_nombre = dt.fuente_espacial_nombre or (fe.fuente_espacial_nombre is null and dt.fuente_espacial_nombre is null))
	and (fe.fuente_espacial_fecha_documento = dt.fuente_espacial_fecha_documento or (fe.fuente_espacial_fecha_documento is null and dt.fuente_espacial_fecha_documento is null))
join pot_fuenteespacial as pf on pf.id_fuente = fe.id_data;

/*
--======================================
--Borrado campos temporales
--===========================================
alter table pot_uab_clasificacionsuelo drop column id_clasificacion_suelo ;
alter table pot_ue_clasificacionsuelo drop column id_clasificacion_suelo ;
alter table pot_uab_zonificacionamenaza  drop column id_zonificacion_amenaza ;
alter table pot_ue_zonificacionamenaza  drop column id_zonificacion_amenaza ;
alter table pot_uab_areacondicionamenaza  drop column id_condicion_amenaza ;
alter table pot_ue_areacondicionamenaza drop column id_condicion_amenaza ;
alter table pot_uab_areacondicionriesgo  drop column id_condicion_riesgo ;
alter table pot_ue_areacondicionriesgo drop column id_condicion_riesgo ;
alter table pot_uab_zonificacionsuelorural drop column id_zonificacion_rural ;
alter table pot_ue_zonificacionsuelorural drop column id_zonificacion_rural ;
alter table pot_uab_tratamientourbanistico drop column id_tratamientos_urbanisticos ;
alter table pot_ue_tratamientourbanistico drop column id_tratamientos_urbanisticos ;
alter table pot_uab_centropobladorural drop column id_centro_poblado ;
alter table pot_ue_centropobladorural  drop column id_centro_poblado ;
alter table pot_uab_areasactividad  drop column id_areas_actividad ;
alter table pot_ue_areasactividad  drop column id_areas_actividad ;
alter table pot_uab_sistemasgenerales  drop column id_sistema_general ;
alter table pot_ue_sistemasgenerales  drop column id_sistema_general ;
alter table pot_uab_sueloproteccionurbano drop column id_suelo_proteccion_urbano;
alter table pot_ua3_sueloproteccionurbano drop column id_suelo_proteccion_urbano;
alter table pot_fuenteadministrativa  drop column id_fuente ;
alter table pot_fuenteespacial drop column id_fuente ;


drop table fuentes_administrativas;
drop table fuentes_espaciales;

*/