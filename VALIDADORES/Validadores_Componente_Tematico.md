# Validadores del componente temático
## CÓDIGO: TM1

**Título:** El centro poblado únicamente corresponde a clasificación de suelo rural.

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| TM1-01 | El registro de Centro Poblado está relacionado con un registro de  clasificación de suelo diferente al Rural |

**SQL PG**

```sql
select	
	puc.t_id,
	puc.t_ili_tid,
	'El registro de Centro Poblado está relacionado con un registro de clasificación de suelo diferente al Rural' as mensaje
from pot_uab_centropobladorural puc 
join pot_uab_clasificacionsuelo pcs on puc.clasificacion_suelo = pcs.t_id 
where pcs.tipo_clasificacion_suelo in (select t_id from pot_clasificacionsuelotipo pc where ilicode not in ('Rural'));
```

## CÓDIGO: TM2

**Título:** La Unidad POT_UAB_ZonificacionAmenazas  deben tener diligenciada Categoría_Amenaza.

**Errores**

| Error  | Descripción                               |
| ------ | ----------------------------------------- |
| TM2-01 | La categoría de amenaza no puede ser NULL |

**SQL PG**

```sql
select
	pua.t_id,
	pua.t_ili_tid,
	'La categoría de amenaza no puede ser NULL' as mensaje
from pot_uab_zonificacionamenazas pua
join pot_derecho pd on pua.t_id = pd.unidad_pot_uab_zonificacionamenazas 
join col_rrrfuente cr on pd.t_id = cr.rrr_pot_derecho 
join pot_fuenteadministrativa pf on pf.t_id = cr.fuente_administrativa
where pua.categoria_amenaza is null and 
(pf.fecha_documento_fuente >= to_date('2014-09-19', 'YYYY-MM-DD') or 
pf.tipo in (select t_id from col_fuenteadministrativatipo where ilicode not like 'Documento_Publico.Acta_Conciliacion' and thisclass like 'LADM_COL_v_2_0_0_Ext_POT.POT_FuenteAdministrativaTipo'));
```

## CÓDIGO: TM3

**Título:**  En la clase POT_UAB_ZonificacionSueloRuralCuando la variable Tipo_Categoria_rural toma el valor Conservacion_Proteccion_Ambiental (Proteccion_Suelo_Rural), el uso principal únicamente puede tomar los valores de Conservacion_Proteccion_Ambiental (Preservacion/Conservacion/Restauracion/Conocimiento/Uso_Sostenible/Disfrute/Historico_Cultural)

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| TM3-01 | El Uso principal rural no tiene relación con el tipo de categoría rural |

**SQL PG**

```sql
select 
	puz.t_id,
	puz.t_ili_tid,
	'El Uso principal rural no tiene relación con el tipo de categoría rural' as mensaje
from pot_uab_zonificacionsuelorural puz
where puz.tipo_categoria_rural  in (select t_id from pot_categoriaruraltipo where ilicode like 'Proteccion_Suelo_Rural.Conservacion_Proteccion_Ambiental.%')
and puz.uso_principal in (select t_id from pot_usosueloruraltipo where ilicode not like 'Conservacion_Proteccion_Ambiental.%');
```

## CÓDIGO: TM4

**Título:**  El uso principal centro poblado solo aplica para categoría de suelo rural de desarrollo restringido, centro poblado rural

**Errores**

| Error  | Descripción                                                  |
| ------ | ------------------------------------------------------------ |
| TM4-01 | Cuando el tipo de uso principal es Centro Poblado, la categoría rural no puede ser diferente de (Desarrollo restringido) Centro poblado en la zona rural |

**SQL PG**

```sql
select 
	puz.t_id,
	puz.t_ili_tid,
	'Cuando el tipo de uso principal es Centro Poblado, la categoria rural no puede ser diferente de (Desarrollo restringido) Centro poblado en la zona rural' as mensaje
from pot_uab_zonificacionsuelorural puz
where (puz.uso_principal in (select t_id from pot_usosueloruraltipo where ilicode like 'Centro_Poblado')
and puz.tipo_categoria_rural  in (select t_id from pot_categoriaruraltipo where ilicode not like 'Desarrollo_Restringido.Centro_Poblado_Rural'));
```