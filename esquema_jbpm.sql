
select * from pje_jbpm.jbpm_task jt ; -- armazena as tarefas dos processos

select * from pje_jbpm.jbpm_taskinstance jt ; -- armazena a tarefa e faz relação com as instancias do processo

select * from pje_jbpm.jbpm_processinstance jp ; -- armazena as instancias de um processo

select * from pje.tb_processo_instance tpi; --tabela que armazena a relação entre o processo e as suas instancias

select * from pje_jbpm.jbpm_processdefinition jp ; -- faz a relação entre o fluxo geral e o processo

select * from pje_jbpm.jbpm_token jt ; --tabela que faz o controle de estados e a execução do fluxo do processo

select * from pje_jbpm.jbpm_node jn ; --tabela de subfluxo do processo

select * from pje_jbpm.jbpm_variableinstance jv ;
--------------------------------------------------------------------------------------------------------------------------------------------

select * from pje.tb_proc_localizacao_ibpm tpli ; -- armazena a relação entre task, processinstance, papel, localizacao e o processo


select * from pje_jbpm.jbpm_moduleinstance jm ; --gerenciar tarefas

select * from pje_jbpm.jbpm_swimlaneinstance js ;--gerenciar os responsaveis por tais tarefas

select * from pje.tb_processo_instance tpi ;

select * from pje.tb_proc_localizacao_ibpm tpli ;


select 
	* 
from pje.tb_processo_instance tpi 
inner join pje_jbpm.jbpm_processinstance jp on tpi.id_proc_inst = jp.id_ 
inner join pje_jbpm.jbpm_taskinstance jt on jp.id_ = jt.procinst_ 
where tpi.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0010227-79.2012.5.07.0011');


select n.id_, n.processdefinition_, p.name_
		from pje_jbpm.jbpm_node n
		join pje_jbpm. jbpm_processdefinition p on (n.processdefinition_ = p.id_)
		where n.name_ = 'Término'
		order by n.id_ desc
		limit 1;
		
	
	
	
	select p3.id_, p5.id_ 
	from tb_processo_instance p1
	join pje_jbpm.jbpm_processinstance p2 on p1.id_proc_inst = p2.id_
	join pje_jbpm.jbpm_moduleinstance p4 on (p2.id_ = p4.processinstance_ and p4.name_ = 'org.jbpm.taskmgmt.exe.TaskMgmInstance')
	join pje_jbpm.jbpm_processinstance p3 on p3.id_ = p2.processdefinition_
	join pje_jbpm.jbpm_swimlaneinstance p5 on (p5.taskmgmtinstance_ = p4.id_)
	where p1.id_processo = (select id_processo from tb_processo where nr_processo = '0000905-64.2024.5.07.0027')
	and p1.in_ativo = 'S'
	and p2.processdefinition_ in
		(
			select p.id_ from pje_jbpm.jbpm_task t
			join pje_jbpm.jbpm_processdefinition p on (t.processdefinition_ = p.id_)
			where t.name_ = 'Análise do Magistrado'
		)
		order by p4.id_ desc, p5.id_ desc limit 1;
	
	
	
	select tk.procinst_, tk.token_ 
	from pje_jbpm.jbpm_taskinstance tk where tk.procinst_ in(
		select psst.id_ from pje_jbpm. jbpm_processinstance psst 
		where psst.id_ in(
			select pit.id_proc_inst from tb_processo_instance pit
			where pit.id_processo = (select id_processo from pje.tb_processo tp where tp.nr_processo = '0000905-64.2024.5.07.0027'))
		and psst.processdefinition_ = (select pssf.id_ from pje_jbpm.jbpm_processdefinition pssf where pssf.name_ ilike 'Fluxo Geral Principal' order by 1 desc limit 1))
	 limit 1; 
	
	
	
	
	select 
		jno.id_ 
	from pje_jbpm.jbpm_node jno
	left join pje_jbpm.jbpm_processdefinition jpd on jpd.id_ = jno.processdefinition_
	where jno.name_ ilike 'Analisar Expediente Secretaria'
	and jpd.name_ ilike 'Fluxo Geral Principal'
	order by jno.id_ desc 
	limit 1;

	
	
	
	
	
	
	
	