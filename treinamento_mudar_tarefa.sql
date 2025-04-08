--*****************************************************************************
-- DESCRICAO: Move os processo para uma tarefa de destino
-- COMO USAR: preencher o número do processo e a tarefa de destino no passo 2.
--*****************************************************************************

--=============================================================================
-- PASSO 1: Criar função para transitar processos
--=============================================================================


create or replace function public.p_ir_para_tarefa(p_nr_processo character varying, p_nome_tarefa character varying)
	returns character varying 
	language plpgsql
as $$

declare 

v_id_taskinstance jbpm_taskinstance.id_%type;
v_id_token jbpm_token.id_%type;
v_procinst jbpm_processinstance.id_%type;
v_id_task jbpm_task.id_%type;
v_id_node jbpm_node.id_%type;
v_id_processo tb_processo.id_processo%type;
v_class varchar;
v_version bigint;
v_swimlaninstance bigint;
v_taskmgmtinstance bigint;
v_pooledactorsexpression varchar; --pares localizacao/papel
v_par varchar; -- par localizacao/papel
v_item1_par varchar; -- 1° item do par localizacao/papel
v_item2_par varchar; -- 2° item do par localizacao/papel
isDestino2G boolean;
procInst2G bigint;
tempIdVI bigint;
token2G bigint;
idNodeFluxo bigint;
v_subprocname_   jbpm_node.subprocname_%TYPE;
v_process_definition_dest jbpm_node.processdefinition_%type;
v_name_process_definition_dest jbpm_processdefinition.name_%type;
v_instancia varchar;
v_string_fluxo_geral varchar;
v_id_tarefa bigint;
v_ds_tarefa varchar;
v_id_task_instance_atual jbpm_taskinstance.id_%type;
v_node_subfluxo_atual jbpm_node.id_%type;

begin 

	-- verificando se o processo está no primeiro ou no segundo grau. 
	--verifica o banco de dados atual e armazena o valor em v_instancia
	select substring(current_database(), 0, 10) into v_instancia;
	
	-- atribuindo a string de fluxo geral de acordo com a instância que está sendo utilizada.
	if v_instancia = 'pje_1grau'
		then v_string_fluxo_geral := '%Fluxo Geral Principal';
	elseif v_instancia = 'pje_2grau'
		then v_string_fluxo_geral := '%2G%';
	else
		return 'Erro ao verificar instancia atual';
	end if;


	
	-- Recuperando o id da tarefa. Recupera o id mais recente.
	select id_ into v_id_task from jbpm_task
	where name_ = ''||p_nome_tarefa||''
	order by id_ desc
	limit 1;


	-- Recuperando - id do node da tarefa a qual será modificada. Recupera o node mais recente.
		select jbpm_node.id_, jbpm_node.processdefinition_, jbpm_processdefinition.name_
		into v_id_node, v_process_definition_dest, v_name_process_definition_dest from jbpm_node
		join jbpm_processdefinition on (jbpm_node.processdefinition_ = jbpm_processdefinition.id_)
		where jbpm_node.name_ = ''||p_nome_tarefa||''
		order by id_desc
		limit 1;
		

	-- Recuperando o id do processo
	select id_processo into v_id_processo
	from tb_processo where nr_processo ilike '%'||p_nr_processo||'%';


	-- Recuperando o swimlaninstance e taskmgmtinstance, que gerenciam as tarefas e os seus responsaveis
	select p3.id_, p5.id_ into v_taskmgmtinstance, v_swimlaninstance
	from tb_processo_instance p1
	join jbpm_processinstance p2 on p1.id_proc_inst = p2.id_
	join jbpm_moduleinstance p4 on (p2.id_ = p4.processinstance_ and p4.name_ = 'org.jbpm.taskmgmt.exe.TaskMgmInstance')
	join jbpm_processdefinition p3 on p3.id_ = p2.processdefinition_
	join jbpm_swimlaneinstance p5 on (p5.taskmgmtinstance_ = p4.id_)
	where p1.id_processo = (select id_processo from tb_processo where nr_processo = p_nr_processo)
	and p1.in_ativo = 'S'
	and p2.processdefinition_ in
		(
			select jbpm_processdefinition.id_ from jbpm_task
			join jbpm_processdefinition on (jbpm_task.processdefinition_ = jbpm_processdefinition.id_)
			where jbpm_task.name_ = p_nome_tarefa;
		)
		order by p4.id_ desc, p5.id_ desc limit 1;
	
		

	-- recuperando a class, version de tarefa destino - swimlaninstance, taskmgmtinstance também serao preenchidos se estiverem vazios
	select class_, version_, coalesce(v_swimlaninstance, swimlaninstance_), coalesce(v_taskmgmtinstance, task_mgmtinstance_)
	into v_class, v_version, v_swimlaninstance, v_taskmgmtinstance
	from jbpm_taskinstance
	where name_ = ''||p_nome_tarefa||''
	order by id_desc
	limit 1;


----------------------------------------------



	  --Pega procinst e token que são do fluxo geral -- s irá alterar se for mudar de subfluxo
  SELECT procinst_, token_ INTO procInst2G, token2G FROM jbpm_taskinstance WHERE procinst_ IN(
  SELECT id_ FROM jbpm_processinstance WHERE id_ IN (
  SELECT id_proc_inst  FROM tb_processo_instance WHERE  id_processo = v_id_processo
  ) AND processdefinition_ = (SELECT id_ FROM jbpm_processdefinition  WHERE name_ ilike v_string_fluxo_geral ORDER BY 1 DESC LIMIT 1)
  ) LIMIT 1;

	--Seleciona o id do node do processo que está relacionado com a tabela processdefinition e que na tabela node tenha o nome da tarefa 
	--que será modificada e na tabela processdefinition tenha o fluxo geral ao qual o processo está atribuido.
	select 
		jno.id_ into v_subprocname_ 
	from jbpm_node jno
	left join jbpm_processdefinition jpd on jpd.id_ = jno.processdefinition_
	where jno.name_ ilike ''||p_nome_tarefa||'' 
	and jpd.name_ ilike v_string_fluxo_geral 
	order by jno.id desc 
	limit 1;

	
	--Condicao de consulta 
	if not found then
		isDestino2G := false;
		raise notice 'v_id_token: %', v_id_token;
		raise notice 'v_procinst: %', v_procinst;
		raise notice 'isDestino2G: %', isDestino2G;
	else
		isDestino2G := true;
		raise notice 'v_id_token0: %', v_id_token;
		raise notice 'v_procinst0: %', v_procinst;
		raise notice 'isDestino2G: %', isDestino2G;
	end if;


	--Pega procinst e token que não são do fluxo geral (token e process instance que vai reabrir)
	select procinst_, token_ into v_procinst, v_id_token from jbpm_taskinstance where procinst_ in(
	select id_ from jbpm_processinstance where id_ in(
	select id_proc_inst from tb_processo_instance where  id_processo = v_id_processo)
	and processdefinition_ <> (select id_ from jbpm_processdefinition where name_ ilike v_string_fluxo_geral order by id_ desc limit 1)
	) order by id_ desc limit 1;

	if not found then 
		--não tem token de subfluxo, então se só pode mandar para tarefa do fluxo geral
		if isDestino2G then
			--tarefa de destino é do fluxo geral então atualiza token do fluxo geral e segue
			--apontando token 2G
			v_id_token := token2G;
			v_procinst := procInst2G;
			raise notice 'v_id_token: %', v_id_token;
			raise notice 'v_procinst: %', v_procinst;
		else
			--não tem oq fazer pq a tarefa é de um subfluxo porém não existe token de subfluxo para usar, teria que criar um novo token
		end if;
	else -- se houver subfluxo
		if isDestino2G then -- se a tarefa de destino for do fluxo geral
			
			--fechando o token
			update jbpm_token set end_ = now(), isabletoreactivateparent_ = false where id_ = v_id_token;
			update jbpm_token set subprocessinstance = null where id_ = token2G;
			
			--Fechando processinstance
			update jbpm_processinstance set end_ = now(), issuspended_ = 't' where id_ = v_procinst;
			v_id_token := token2G;
			v_procinst := procInst2G;
			raise notice 'v_id_token 2: %', v_id_token;
			raise notice 'v_procinst 2: %', v_procinst;
		else -- se a tarefa de destino não for do fluxo geral
			select ti.id_ into v_id_task_instance_atual
			from tb_processo_instance proc_inst
			join jbpm_processinstance p on (proc_inst.id_proc_inst = p.id_ and proc_inst.in_ativo = 'S')
			join jbpm_taskinstance ti on (ti.procinst_ = p.id_)
			where id_processo = (select id_processo from tb_processo where nr_processo = p_nr_processo)
			order by ti.id_ desc limit 1;


		-- PJEKZ-13995 -> Tarefa atual e a nova são do mesmo fluxo? Nesse caso deve ser mantida a referência ao mesmo subprocesso do fluxo
        -- Ex.: Se "Remessa ao 2o grau - Exec", então deve continuar fazendo referência a "Remessa ao 2o grau - Exec" na nova tarefa
		
		select 
			(select max(nd1.id_) from jbpm_node nd1 where nd1.name_ = pje_jbpm.jbpm_node.name_) into v_node_subfluxo_atual
		from pje_jbpm.jbpm_node node 
		inner join pje_jbpm.jbpm_token tn on tn.node_ = node.id_
		inner join pje_jbpm.jbpm_processinstance pst on ( pst.superprocesstoken_ = tn.id_ and tn.processistance_ = pst.id_)
		inner join pje_jbpm.jbpm_taskinstance tk on tk.token_ = tn.id_
		where tk.id_ = v_id_task_instance_atual 
		and subprocname_ = v_name_process_definition_dest;

		if found then 
			idNodeFluxo := v_node_subfluxo_atual;
		else
			--Pega node do subfluxo para setar em token 2G
			select id_ into idNodeFluxo from jbpm_node where jbpm_node.subprocname_ ilike '%' ||(select name_ from jbpm_processdefinition where id_ =
			(select processdefinition_ from jbpm_node where name_ = ''||p_nome_tarefa||'' order by id_ desc limit 1))||'%'
			order by id_ desc limit 1;
		end if;
		
		--Tarefa é de subfluxo então abre token de subfluxo e atualiza token do fluxo geral (subprocessinstance)
		--Atualizando processinstance
		update jbpm_processinstance set superprocesstoken_ = token2G where id_ = v_procinst;
		
		--Apontando token do fluxo geral
		update jbpm_token set end_ = null, isabletoreactivaparent_ = 't', lock_ = null, node_ = idNodeFluxo, subprocessinstance_ = v_procinst 
		where id_ = token2G; --ok

		raise notice 'v_id_token 3: %', v_id_token;
		raise notice 'v_procinst 3: %', v_procinst;
		end if;
		end if;

	-- fechando a tarefa atual
	update jbpm_takinstance 
		set end_ = now(), isopen_ = false 
	where id_ in (select id_ from jbpm_taskinstance where procinst_ in (select id_proc_inst from tb_processo_instance where id_processo = v_id_processo))
	and end_ is null;

	--Apontando token para a tarefa destino
	 update jbpm_token set node_ = v_id_node, end_ = null, isabletoreactivateparent_ = true, lock_ = null where id_ = v_id_token;

	--Reabrindo processistance
	update jbpm_processinstance set end = null, issuspended_ = 'f', processdefinition_ = v_process_definition_dest where id_ = v_procinst;

	
	--Insere a nova tarefa
	insert into jbpm_taskinstance (id_, class_, version_, name_, description_, actorid_ create_, start_, end_, duedate_ priority_, iscancelled_,  issuspended_, isopen_ issignalling,
	isbloacking_, task_, token_, procinst_, swimlaninstance_, taskmgmtinstance_)
	values (nextval('hibernate_sequence'), v_class, v_version, p_nome_tarefa, null, null, now(), now(), null, null, 3, false, false, true, true, false, v_id_task, v_id_token, v_procinst,
	v_swimlaninstance, v_taskmgmtinstance);

	-- Atualiza tb_processo_tarefa
	select t.id_tarefa, t.ds_tarefa from tb_tarefa t where t.ds_tarefa = p_nome_tarefa
	into v_id_tarefa, v_ds_tarefa;

	--Deleta a localização antiga do processo
	delete from tb_processo_tarefa where id_processo_trf = v_id_processo;

	--Insere a nova localização do processo
	insert into tb_processo_tarefa(id_processo_trf, id_tarefa, id_task, id_processinstance, dh_criacao_tarefa, id_token, id_taskinstance, nm_tarefa)
	select v_id_processo, v_id_tarefa, ti.task_, ti.procinst_, ti.create_, ti.token_, ti.id_, p_nome_tarefa
	from jbpm_taskinstance ti
	inner join jbpm_processinstance p on ti.procinst_ = p.id_
	inner join jbpm_processdefinition pd on p.processdefinition_ = pd.id_
	where ti.procinst_ in
	(select id_proc_inst from tb_processo_instance where id_processo = v_id_processo)
	order by ti.create_ desc
	limit 1;



	--Atualiza tb_res_escaninho
	update tb_res_escaninho set nm_tarefa = v_ds_tarefa, id_tarefa = v_id_task where id_processo = v_id_processo;

	--recupera os pares localizacao/papel
	select replace(replace(pooledactorsexpression_, '#{localizacaoAssignment.getPooledActors(''', ''), ''')}', '')
	into v_pooledactorsexpression
	from jbpm_swimlane
	where id_ = (select swimlane_ from jbpm_swimlaneinstance where id_ = v_swimlaninstance);

	--remove a visibilidade do processo
	delete from tb_proc_localizacao_ibpm where id_processo = v_id_processo;

	--loop pegando o par (localizacao/papel) e passando para a função retornar os valores separados
	foreach v_par in array STRING_TO_ARRAY(v_pooledactorsexpression, ',') loop --converte v_pooledactorexpression em um array de strings, delimitado por : ,

		-- decodificar os itens do par (nnnn:nnnn) 12:34
		v_item1_par := substring(v_par from 1 for position(':' in v_par) - 1); --recebe 12,  que é o valor antes do caractere 
		v_item2_par := substring(v_par from position (':' in v_par) + 1); -- recebe 34, que é o valor depois do caractere 

		-- insere o par localizacao/papel -- converte v_item1_par e v_item2_par para integer
	insert into tb_proc_localizacao_ibpm (id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel)
	values (v_id_task, v_procinst, v_id_processo, v_item1_par::integer, v_item2_par::integer);

end loop;

	-- retira da caixa
	update tb_processo set id_caixa = null where id_processo = v_id_processo;

	--Apagar o lixo
	delete from jbpm_variableinstance 
	where processinstance_ in (select id_proc_inst from tb_processo_instance where id_processo = v_id_processo)
   and (bytearrayvalue_ is not null or name_ ilike '%minutaemelaboracao' or name_ ilike '%modelo');


	-- atualizar referencias "frameDefaultLeavingTransition: Término"
	select vi.id_ into tempIdVI from jbpm_variableinstance vi, 
	(select id_, procinst_ from jbpm_taskinstance where procinst_ in (
		select id_proc_inst from tb_processo_instance where id_processo = v_id_processo)) and end_ is null) as t
	where vi.processinstance_ = t.procinst_ 
	and vi.name_ = 'frameDefaultLeavingTransition'
	and vi.stringvalue_ = 'Término';
	
	if not found then
		insert into jbpm_variableinstance(id_, class_, version_, name_, token_, processinstance_, stringvalue_, taskinstance_)
		values (nextval('hibernate_sequence'), 'S', 0, 'frameDefaultLeavingTransition', v_id_token, v_procinst, 'Término',
		 (select id_ from jbpm_taskinstance where procinst_ in(select id_proc_inst from tb_processo_instance where id_processo = v_id_processo) order by id_ desc limit 1));
else
	update jbpm_variableinstance set taskinstance_ = t.id_ from (select id_, procinst_ from jbpm_taskistance where procinst_ in
		(select id_proc_inst from tb_processo_instance where id_processo = v_id_processo) and end_ is null) as t
		where jbpm_variableinstance.processinstance_ = t.procinst_ 
		and jbpm_variableinstance.name_ = 'frameDefaultLeavingTransition'
		and jbpm_variableinstance.stringvalue_ = 'Término';
end if;

return 'Scripts aplicados com sucesso total'

end;

--acabei a revisão
-------------------------------------------------------- ----PAREI POR AQUI A REVISÃO ---- --------------------------------------------------------------------

$$;


--=============================================================================
-- PASSO 2: Executar rotina para mover processos
--=============================================================================

-- Executar a funcao que move os processos

do $$

declare
	
	p_nr_processo character varying := 'numero do processo';
	p_nome_tarefa character varying := 'nome da tarefa';

begin
		perform public.p_ir_para_tarefa(p_nr_processo, p_nome_tarefa);
end;
$$;


--=============================================================================
-- PASSO 3: Remover função criada
--=============================================================================

drop function public.p_ir_para_tarefa(p_nr_processo character varying, p_nome_tarefa character varying);
























