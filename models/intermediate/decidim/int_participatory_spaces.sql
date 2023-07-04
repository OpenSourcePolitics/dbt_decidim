select *
from {{ ref("stg_assemblies")}}
    union all
select *
from {{ ref("stg_participatory_processes")}}
