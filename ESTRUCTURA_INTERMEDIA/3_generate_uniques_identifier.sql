
/***************************************************************************
           Generación ID de las clases de estructura de datos intermedia
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
	public;

--==========================================
--Creación de las llaves
--==========================================

--========================================
--Área de condición de amenaza
--========================================
alter table area_condicion_amenaza add id_data bigint;

with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from area_condicion_amenaza
)
update area_condicion_amenaza set 
id_data = cte.rn
from cte
where area_condicion_amenaza.ctid = cte.id;

--========================================
--Área de condición de riesgo
--========================================
alter table area_condicion_riesgo add id_data bigint;

with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from area_condicion_riesgo
)
update area_condicion_riesgo set 
id_data = cte.rn
from cte
where area_condicion_riesgo.ctid = cte.id;

--========================================
--Áreas de actividad
--========================================
alter table areas_actividad  add id_data bigint;

with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from areas_actividad
)
update areas_actividad set 
id_data = cte.rn
from cte
where areas_actividad.ctid = cte.id;

--========================================
--Centro poblado
--========================================
alter table centro_poblado_rural add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from centro_poblado_rural
)
update centro_poblado_rural set 
id_data = cte.rn
from cte
where centro_poblado_rural.ctid = cte.id;

--========================================
--Clasificación de suelo 
--========================================
alter table clasificacion_suelo add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from clasificacion_suelo
)
update clasificacion_suelo set 
id_data = cte.rn
from cte
where clasificacion_suelo.ctid = cte.id;

--========================================
--Sistemas generales
--========================================
create table sistemas_generales as (
select * from sistemas_generales_linea sgl 
	union
select * from sistemas_generales_poligono sgp
	union
select * from sistemas_generales_punto sgp);


alter table sistemas_generales add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from sistemas_generales
)
update sistemas_generales set 
id_data = cte.rn
from cte
where sistemas_generales.ctid = cte.id;

--========================================
-- Suelo de protección urbano
--========================================
alter table suelo_proteccion_urbano add id_data bigint;

with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from suelo_proteccion_urbano
)
update suelo_proteccion_urbano set 
id_data = cte.rn
from cte
where suelo_proteccion_urbano.ctid = cte.id;

--========================================
--Tratamientos urbanistico
--========================================
alter table tratamiento_urbanistico add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from tratamiento_urbanistico
)
update tratamiento_urbanistico set 
id_data = cte.rn
from cte
where tratamiento_urbanistico.ctid = cte.id;

--========================================
--Zonificación de amenazas
--========================================
alter table zonificacion_amenaza add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from zonificacion_amenaza
)
update zonificacion_amenaza set 
id_data = cte.rn
from cte
where zonificacion_amenaza.ctid = cte.id;

--========================================
--Zonificación de suelo rural
--========================================
alter table zonificacion_suelo_rural add id_data bigint;
with cte as (
  select ctid as id, ROW_NUMBER() OVER () AS rn
  from zonificacion_suelo_rural
)
update zonificacion_suelo_rural set 
id_data = cte.rn
from cte
where zonificacion_suelo_rural.ctid = cte.id;