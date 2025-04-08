

delete
from pje_jbpm.jbpm_variableinstance k
where k.processinstance_ in (
     select id_proc_inst
     from pje.tb_processo_instance o
     where o.id_processo in (SELECT id_processo FROM pje.TB_PROCESSO l where l.nr_processo in ('0000379-83.2017.5.07.0014'))
)
and ((bytearrayvalue_ is not null and name_ <> 'intimacaoAutomatica:destinatarios') or 
name_ ILIKE ANY (array['%minutaemElaboracao', '%minutaarquivamento', '%modelo', '%temp%', 'prevencao:%', '%pje:atoProferido%']));

select * from pje_jbpm.jbpm_variableinstance jv where processinstance_ in (select id_proc_inst
from pje.tb_processo_instance where id_processo in (select id_processo from tb_processo where nr_processo in ('0000379-83.2017.5.07.0014')))
and ((bytearrayvalue_ is not null and name_ <> 'intimacaoAutomatica:destinatarios')) or name_ ilike any 
(array['%minutaemElaboracao', '%minutaarquivamento', '%modelo', '%temp', 'prevencao:%', 'pje:atoProferido%']);


select jv.*
from pje.tb_processo tp
join pje.tb_processo_instance tpi on tpi.id_processo = tp.id_processo
join pje_jbpm.jbpm_variableinstance jv on jv.processinstance_ = tpi.id_proc_inst
join pje.tb_processo_tarefa tpt on tpt.id_processo_trf = tp.id_processo
where 1=1
and tpt.id_processinstance = jv.processinstance_
and tpt.id_taskinstance = jv.taskinstance_
and tp.nr_processo = '0000379-83.2017.5.07.0014'
order by jv.id_ desc;



do $PROC794024$
declare
    var_id_taskinst integer;
begin
 
-- Inserir variavel de fluxo 'frameDefaultLeavingTransition' = 'Término'
delete from jbpm_variableinstance where name_ = 'frameDefaultLeavingTransition' and token_ = 278679873 and processinstance_ = 278679872;
insert into jbpm_variableinstance (id_, class_, version_, name_, token_, processinstance_, stringvalue_, taskinstance_)
    values (nextval('hibernate_sequence'), 'S', 0, 'frameDefaultLeavingTransition', 278679873, 278679872, 'Término', 278679896);
 
end $PROC794024$ language plpgsql;


