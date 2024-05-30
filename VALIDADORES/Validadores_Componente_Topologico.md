# Validadores del componente topológico

## CÓDIGO: T1

**Título:** No puede existir superposición en la representación espacial de la clasificación del suelo.

**Errores**

| Error | Descripción                                                  |
| ----- | ------------------------------------------------------------ |
| T1-01 | El registro categoría de suelo rural   *T_Id.1* se superpone con el registro *T_Id.2* |

**SQL PG**

```sql
select
	puc1.t_id,
	puc2.t_ili_tid,
	concat('El registro categoría de suelo rural',puc1.t_id,' se superpone con el registro',puc2.t_id) as mensaje
from pot_ue_clasificacionsuelo as puc1
join pot_ue_clasificacionsuelo as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;
```

## CÓDIGO: T5

**Título:** No pueden existir superposiciones entre los polígonos que hacen parte de las categorías de  zonificación de suelo rural.

**Errores**

| Error | Descripción                                                  |
| ----- | ------------------------------------------------------------ |
| T5-01 | El registro de zonificación de suelo rural   *T_Id.1* se superpone con el registro *T_Id.2* |

**SQL PG**

```sql
select
	puc1.t_id,
	puc2.t_ili_tid,
	concat('El registro de zonificación de suelo rural ',puc1.t_id,' se superpone con el registro',puc2.t_id) as mensaje
from pot_ue_zonificacionsuelorural as puc1
join pot_ue_zonificacionsuelorural as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;
```

## CÓDIGO: T6

**Título:** No puede existir superposición en la representación espacial de las categorías de tratamientos urbanísticos.

**Errores**

| Error | Descripción                                                  |
| ----- | ------------------------------------------------------------ |
| T6-01 | El registro de tratamiento urbanístico  *T_Id.1* se superpone con el registro *T_Id.2* |

**SQL PG**

```sql
select
	puc1.t_id,
	puc1.t_ili_tid,
	concat('El registro de tratamiento urbanístico ',puc1.t_id,' se superpone con el registro ',puc2.t_id) as mensaje
from pot_ue_tratamientourbanistico as puc1
join pot_ue_tratamientourbanistico as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;
```

## CÓDIGO: T8

**Título: **No puede existir superposición en la representación espacial de las categorías de áreas de Actividad

**Errores**

| Error | Descripción                                                  |
| ----- | ------------------------------------------------------------ |
| T8-01 | El registro de área de actividad  *T_Id.1* se superpone con el registro *T_Id.2* |

**SQL PG**

```sql
select
	puc1.t_id,
	puc1.t_ili_tid,
	concat('El registro de área de actividad ',puc1.t_id,' se superpone con el registro ',puc2.t_id) as mensaje
from pot_ue_areasactividad as puc1
join pot_ue_areasactividad as puc2 on st_overlaps(puc1.geometria,puc2.geometria)
where puc1.t_id != puc2.t_id;
```

## CÓDIGO: T10

**Título:** La unidad espacial POT_UE_AreasActividad debe cubrir la totalidad del suelo urbano POT_UE_ClasificacionSuelo.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T10-01 | La siguiente zona del perímetro urbano no está cubierta por registros de las áreas de actividad |

**SQL PG**

```sql
select
	'La siguiente zona del perímetro urbano no está cubierta por registros de las áreas de actividad' as mensaje,
	st_difference(ctc.geometria,arc.geometria) as geometria
from
(select
	st_union(pua.geometria) as geometria
from pot_ue_areasactividad pua) as arc
join
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode like 'Urbano')) as ctc
on st_intersects(arc.geometria, ctc.geometria);
```

## CÓDIGO: T12

**Título:** La unidad espacial POT_UE_TratamientoUrbanistico debe cubrir la totalidad de las clases de suelo Urbano y Expansion_Urbana en la unidad espacial POT_UE_ClasificacionSuelo.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T12-01 | La siguiente zona del perímetro urbano y de expansión urbana no está cubierta por registros de tratamientos urbanos |

**SQL PG**

```sql
select
	'La siguiente zona del perímetro urbano y de expansión urbana no está cubierta por registros de tratamientos urbanos' as mensaje,
	st_difference(ctc.geometria,ttu.geometria) as geometria
from
(select
	st_union(pua.geometria) as geometria
from pot_ue_tratamientourbanistico pua) as ttu
join
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode in ('Urbano','Expansion_Urbana'))) as ctc
on st_intersects(ttu.geometria, ctc.geometria);
```

## CÓDIGO: T13

**Título:** La unidad espacial POT_UE_SistemasGenerales en geometría de tipo línea de la categoría *Vías* no  pueden estar duplicadas ni estar superpuestas entre ellas.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T13-01 | El registro de sistemas generales de tipo vías *T_Id.1* presenta superposición con el registro *T_Id.2* |

**SQL PG**

```sql
select
	st1.t_id,
	st1.t_ili_tid,
	concat('El registro de sistemas generales de tipo vías ',st1.t_id,' presenta superposición con el registro ',st2.t_id) as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Vias.%')) as st1
join (select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Vias.%')) as st2 on st_intersects(st1.geometria,st2.geometria)
where st1.t_id != st2.t_id and  not st_touches(st1.geometria,st2.geometria)
order by st1.t_id  asc;
```

## CÓDIGO: T15

**Título:** La unidad espacial POT_UE_SistemasGenerales en geometría de tipo punto de las categorías (*Equipamientos, Servicios_Publicos  y Infraestructura_Transporte)* no pueden estar superpuestas.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T13-01 | El registro de sistemas generales de tipo vías *T_Id.1* presenta superposición con el registro *T_Id.2* |

**SQL PG**

```sql
select
	st1.t_id, 
	st1.t_ili_tid,
	concat('El registro de sistemas generales ',st1.t_id,' presenta superposición con el registro ',st2.t_id) as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria 
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referenciapuntosistemasgenerales pr on pr.sistemagenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join pot_referenciapuntosistemasgenerales as st2
on st_intersects(st1.geometria,st2.geometria)
where st1.t_id != st2.t_id;
```

## CÓDIGO: T16

**Título:**  La unidad espacial POT_UE_SistemasGenerales de las categorías (*Vias, Servicios_Publicos e Infraestructura_Transporte*) no deberían estar  por fuera de la unidad espacial POT_UE_ClasificacionSuelo.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T16-01 | El registro de geometria punto de la tabla  pot_referenciapuntosistemasgenerales no está contenido por la unidad espacial  de clasificación de suelo |
| T16-02 | El registro de geometria linea de la tabla  pot_referencialineasistemasgenerales no está contenido por la unidad espacial  de clasificación de suelo |
| T16-03 | El registro de geometria poligono   la tabla pot_ue_sistemasgenerales no está contenido por la unidad  espacial de clasificación de suelo |

**SQL PG**

```sql
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria punto de la tabla pot_referenciapuntosistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referenciapuntosistemasgenerales pr on pr.sistemagenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
union
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria linea de la tabla pot_referencialineasistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pr.t_id,
	pr.t_ili_tid,
	pr.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
join pot_referencialineasistemasgenerales pr on pr.sistemasgenerales = pus2.t_id 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
union
select
	st1.t_id, 
	st1.t_ili_tid,
	'El registro de geometria poligono  la tabla pot_ue_sistemasgenerales no está contenido por la unidad espacial de clasificación de suelo' as mensaje
from 
(select
	pus2.t_id,
	pus2.t_ili_tid,
	pus2.geometria
from pot_uab_sistemasgenerales pus 
join col_uebaunit cu  on pus.t_id = cu.baunit_pot_uab_sistemasgenerales 
join pot_ue_sistemasgenerales pus2 on pus2.t_id = cu.ue_pot_ue_sistemasgenerales 
where pus.tipo_sistema_general in (select t_id from pot_sistemasgeneralestipo  where ilicode like 'Servicios_Publicos.%' or ilicode like 'Vias.%' or ilicode like 'Infraestructura_Transporte.%')
and pus2.geometria is not null) as st1
join (select st_union(cs.geometria) as geometria from pot_ue_clasificacionsuelo as cs) as cs1
on st_contains(cs1.geometria,st1.geometria) = false
order by mensaje desc;
```

## CÓDIGO: T17

**Título:** Los centros poblados deben estar contenidos dentro del polígono de clasificación de suelo rural.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T17-01 | El centro poblado no esta contenido por la clasificación del suelo rural |

**SQL PG**

```sql
select
	puc.t_id,
	puc.t_ili_tid,
	'El centro poblado no esta contenido por la clasificación del suelo rural' as mensaje
from pot_ue_centropobladorural puc 
join 
(select
	st_union(puc.geometria) as geometria 
from pot_ue_clasificacionsuelo as puc 
join col_uebaunit as cu on puc.t_id = cu.ue_pot_ue_clasificacionsuelo
join pot_uab_clasificacionsuelo as pc on pc.t_id  = cu.baunit_pot_uab_clasificacionsuelo
where pc.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo where ilicode in ('Rural'))) as ctc
on st_contains(ctc.geometria,puc.geometria) = false;
```

## CÓDIGO: T18

**Título: ** Los límites del polígono de centro poblado y del polígono de centro poblado rural de la categoría desarrollo restringido de la zonificación de suelo rural deben ser coincidentes.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| T18-01 | El centro poblado no tiene un registro de zonificación rural con equivalencia geométrica |

**SQL PG**

```sql
select 
	puc.t_id,
	puc.t_ili_tid,
	'El centro poblado no tiene un registro de zonificación rural con equivalencia geométrica' as mensaje
from pot_ue_centropobladorural puc 
where puc.t_id not in (
select puc.t_id  
from pot_uab_zonificacionsuelorural puz
join col_uebaunit cu on puz.t_id = cu.baunit_pot_uab_zonificacionsuelorural
join pot_ue_zonificacionsuelorural ps on ps.t_id = cu.ue_pot_ue_zonificacionsuelorural 
join pot_ue_centropobladorural puc on st_equals(ps.geometria,puc.geometria)
where puz.uso_principal in (select t_id from pot_usosueloruraltipo pu where ilicode like 'Centro_Poblado'));
```