--*****************************************************************************
-- DESCRICAO: Move os processo para uma tarefa de destino
-- COMO USAR: preencher o número do processo e a tarefa de destino no passo 2.
--*****************************************************************************

--=============================================================================
-- PASSO 1: Criar função para transitar processos
--=============================================================================

-- Função obtida dos colegas do TRT-9
CREATE OR REPLACE FUNCTION public.p_ir_para_tarefa(p_nr_processo character varying, p_nome_tarefa character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $$

/* 
	Function: trt9.p_ir_para_tarefa(character varying, character varying)
	12/05/2019 | 2.3.3 | kaiosantos  | PJEKZ-13995| Mantendo referência do subfluxo quando tarefa destino pertence ao mesmo fluxo da tarefa atual
	11/10/2018 | 2.2.1 | kaiosantos  | PJEKZ-6415 | Corrigindo a referência do taskmgmtinstance_ e swimlaninstance_
	24/09/2018 | 2.2.1 | marcoskay   | PJEKZ-6278 | Excluindo e incluindo tb_processo_tarefa a exemplo de PJEKZ-5958  
	16/05/2018 | 2.1.4 | kaiosantos  | PJEKZ-2589 | Falha na movimentação de processos
	18/03/2015 | 1.4.8 | marcokeller | PJEJT-12058| Movimentar processo para "Assinar acórdão"
*/  

DECLARE

  v_id_taskinstance         BIGINT;
  v_id_token                BIGINT;
  v_procinst                BIGINT;
  v_id_task                 BIGINT;
  v_id_node                 BIGINT;
  v_id_processo             BIGINT;
  v_class                   VARCHAR;
  v_version           BIGINT;
  v_swimlaninstance         BIGINT;
  v_taskmgmtinstance        BIGINT;
  v_pooledactorsexpression  VARCHAR; -- pares localizacao/papel
  v_par VARCHAR; -- par localizacao/papel
  v_item1_par VARCHAR; -- 1º item do par localizacao/papel
  v_item2_par VARCHAR; -- 2º item do par localizacao/papel
  isDestino2G BOOLEAN;
  procInst2G BIGINT;
  tempIdVI BIGINT;
  token2G BIGINT;
  idNodeFluxo BIGINT;
  v_subprocname_ jbpm_node.subprocname_%TYPE;
  v_process_definition_dest jbpm_node.processdefinition_%TYPE;
  v_name_process_definition_dest jbpm_processdefinition.name_%TYPE;
  v_instancia VARCHAR;
  v_string_fluxo_geral 	VARCHAR;
  v_id_tarefa		BIGINT;
  v_ds_tarefa		VARCHAR;
  v_id_task_instance_atual	jbpm_taskinstance.id_%TYPE;
  v_node_subfluxo_atual	jbpm_node.id_%TYPE;
BEGIN

  -- verificando se o processo está no primeiro ou no segundo grau.
  SELECT SUBSTRING(current_database(),0,10) INTO v_instancia;

  -- atribuindo a string de fluxo geral de acordo com a instância que está sendo utilizada.
  IF v_instancia = 'pje_1grau'
    THEN v_string_fluxo_geral := '%Fluxo Geral Principal%';
  ELSEIF v_instancia = 'pje_2grau'
    THEN v_string_fluxo_geral := '%2G%';
  ELSE
    RETURN 'Erro ao verificar instância atual';
  END IF;

  -- recuperando o id da tarefa
  SELECT id_
      INTO v_id_task
      FROM jbpm_task
      WHERE name_ = ''||p_nome_tarefa||''
      ORDER BY id_ DESC
      LIMIT 1;

  -- recuperando o id do node da tarefa
  SELECT jbpm_node.id_, jbpm_node.processdefinition_, jbpm_processdefinition.name_
      INTO v_id_node, v_process_definition_dest, v_name_process_definition_dest
      FROM jbpm_node
      JOIN jbpm_processdefinition ON (jbpm_node.processdefinition_ = jbpm_processdefinition.id_)
      WHERE jbpm_node.name_ = ''||p_nome_tarefa||''
      ORDER BY id_ DESC
      LIMIT 1;

  -- recuperando o id do processo
  SELECT id_processo
      INTO v_id_processo
      FROM tb_processo
      WHERE nr_processo ilike '%'||p_nr_processo||'%';

  -- recuperando o swimlaninstance e taskmgmtinstance
  SELECT jbpm_moduleinstance.id_, jbpm_swimlaneinstance.id_ INTO v_taskmgmtinstance, v_swimlaninstance
	FROM tb_processo_instance
	JOIN jbpm_processinstance ON (tb_processo_instance.id_proc_inst = jbpm_processinstance.id_)
	JOIN jbpm_moduleinstance ON (jbpm_processinstance.id_ = jbpm_moduleinstance.processinstance_ AND jbpm_moduleinstance.name_ = 'org.jbpm.taskmgmt.exe.TaskMgmtInstance')
	JOIN jbpm_processdefinition ON (jbpm_processdefinition.id_ = jbpm_processinstance.processdefinition_)
	JOIN jbpm_swimlaneinstance ON (jbpm_swimlaneinstance.taskmgmtinstance_ = jbpm_moduleinstance.id_)
	where id_processo = (SELECT id_processo FROM tb_processo WHERE nr_processo = p_nr_processo)
	AND tb_processo_instance.in_ativo = 'S'
	AND jbpm_processinstance.processdefinition_ in
	(	
		SELECT jbpm_processdefinition.id_ FROM jbpm_task 
		JOIN jbpm_processdefinition ON (jbpm_task.processdefinition_ = jbpm_processdefinition.id_)
		where jbpm_task.name_ = p_nome_tarefa
	)
       ORDER BY jbpm_moduleinstance.id_ DESC, jbpm_swimlaneinstance.id_ DESC limit 1;

  -- recuperando a class, version de tarefa destino - swimlaninstance, taskmgmtinstance também serao preenchidos se estiverem vazios
  SELECT class_, version_, COALESCE(v_swimlaninstance, swimlaninstance_), COALESCE(v_taskmgmtinstance, taskmgmtinstance_)
      INTO v_class, v_version, v_swimlaninstance, v_taskmgmtinstance
      FROM jbpm_taskinstance 
      WHERE name_ = ''||p_nome_tarefa||''
      ORDER BY id_ DESC
      LIMIT 1;

  --Pega procinst e token que são do fluxo geral -- s irá alterar se for mudar de subfluxo
  SELECT procinst_, token_ INTO procInst2G, token2G FROM jbpm_taskinstance WHERE procinst_ IN(
  SELECT id_ FROM jbpm_processinstance WHERE id_ IN (
  SELECT id_proc_inst  FROM tb_processo_instance WHERE  id_processo = v_id_processo
  ) AND processdefinition_ = (SELECT id_ FROM jbpm_processdefinition  WHERE name_ ilike v_string_fluxo_geral ORDER BY 1 DESC LIMIT 1)
  ) LIMIT 1;
  
 --Parei aqui
  SELECT jno.id_ INTO v_subprocname_ FROM jbpm_node jno
  LEFT JOIN jbpm_processdefinition jpd ON jpd.id_ = jno.processdefinition_
  WHERE jno.name_ ilike ''||p_nome_tarefa||'' AND jpd.name_ ilike v_string_fluxo_geral ORDER BY jno.id_ DESC LIMIT 1;
  IF NOT found THEN
    isDestino2G := FALSE;
    RAISE NOTICE 'v_id_token: %',v_id_token;
    RAISE NOTICE 'v_procinst: %',v_procinst;
    RAISE NOTICE 'isDestino2G: %',isDestino2G;
  ELSE
    isDestino2G := TRUE; --set true
    RAISE NOTICE 'v_id_token0: %',v_id_token;
    RAISE NOTICE 'v_procinst0: %',v_procinst;
    RAISE NOTICE 'isDestino2G: %',isDestino2G;
  END IF;

--Pega procinst e token que não são do fluxo geral (token e process instance que vai reabrir)
  SELECT procinst_, token_ INTO v_procinst, v_id_token FROM jbpm_taskinstance WHERE procinst_ IN(
  SELECT id_ FROM jbpm_processinstance WHERE id_ IN (
  SELECT id_proc_inst  FROM tb_processo_instance WHERE  id_processo = v_id_processo) 
  AND processdefinition_ <> (SELECT id_ FROM jbpm_processdefinition  WHERE name_ ilike v_string_fluxo_geral ORDER BY 1 DESC LIMIT 1)
  ) ORDER BY id_ DESC LIMIT 1;

  IF NOT found THEN --ok --só tem fluxo geral: 18457
    --Não tem token de subfluxo, então se só pode mandar para tarefa do fluxo geral.
    IF isDestino2G THEN
      --Tarefa de destino é do fluxo geral então atualiza token do fluxo geral e segue.
      --Apontando token 2G
      v_id_token := token2G;
      v_procinst := procInst2G;
      RAISE NOTICE 'v_id_token: %',v_id_token;
      RAISE NOTICE 'v_procinst: %',v_procinst;
    ELSE
      --não tem oq fazer pq a tarefa é de um subfluxo porém não existe token de subfluxo para usar, teria que criar um novo token
    END IF;
  ELSE --tem subfluxo: 1723893;1723894 e isDestino2G é true (fluxo geral é: --ProcInst: 1666071; Token: 1666072 )
    --tem subfluxo mas está em fluxo geral: 18461
    --está em subfluxo: 17229
    --tem token de subfluxo
    IF isDestino2G THEN
      --Tarefa destino é do fluxo geral então fecha token do subfluxo e segue.
      --fecha token do subfluxo
      UPDATE jbpm_token SET end_ = now(), isabletoreactivateparent_ = FALSE WHERE id_ = v_id_token;
      UPDATE jbpm_token SET subprocessinstance_ = NULL WHERE id_ = token2G;

      --Fechando processinstance
      UPDATE jbpm_processinstance SET end_ = now(), issuspended_ = 't' WHERE id_ = v_procinst;
      v_id_token := token2G;
      v_procinst := procInst2G;
      RAISE NOTICE 'v_id_token 2: %',v_id_token;
      RAISE NOTICE 'v_procinst 2: %',v_procinst;
    ELSE
      SELECT ti.id_ INTO v_id_task_instance_atual
      FROM tb_processo_instance proc_inst
      JOIN jbpm_processinstance pi ON (proc_inst.id_proc_inst = pi.id_ AND proc_inst.in_ativo = 'S')
      JOIN jbpm_taskinstance ti ON (ti.procinst_ = pi.id_)
      WHERE id_processo = (SELECT id_processo FROM tb_processo WHERE nr_processo = p_nr_processo)
      ORDER BY ti.id_ DESC limit 1;
	  
      -- PJEKZ-13995 -> Tarefa atual e a nova são do mesmo fluxo? Nesse caso deve ser mantida a referência ao mesmo subprocesso do fluxo
      -- Ex.: Se "Remessa ao 2o grau - Exec", então deve continuar fazendo referência a "Remessa ao 2o grau - Exec" na nova tarefa
      SELECT (SELECT MAX(nd1.id_) FROM jbpm_node nd1 where name_ = pje_jbpm.jbpm_node.name_) INTO v_node_subfluxo_atual
      FROM pje_jbpm.jbpm_node
      INNER JOIN pje_jbpm.jbpm_token ON pje_jbpm.jbpm_node.id_ = pje_jbpm.jbpm_token.node_
      INNER JOIN pje_jbpm.jbpm_processinstance ON pje_jbpm.jbpm_token.id_ = pje_jbpm.jbpm_processinstance.superprocesstoken_
      INNER JOIN pje_jbpm.jbpm_token AS jbpm_token_1 ON pje_jbpm.jbpm_processinstance.id_ = jbpm_token_1.processinstance_
      INNER JOIN pje_jbpm.jbpm_taskinstance ON jbpm_token_1.id_ = pje_jbpm.jbpm_taskinstance.token_
      WHERE pje_jbpm.jbpm_taskinstance.id_  = v_id_task_instance_atual AND subprocname_ = v_name_process_definition_dest;
      IF found THEN
            idNodeFluxo:= v_node_subfluxo_atual;
      ELSE
            --Pega node do subfluxo para setar em token 2G
            SELECT id_ INTO idNodeFluxo FROM jbpm_node WHERE subprocname_ ilike '%'||(SELECT name_ FROM jbpm_processdefinition WHERE id_ =
            (SELECT processdefinition_ FROM jbpm_node WHERE name_ = ''||p_nome_tarefa||'' ORDER BY id_ DESC LIMIT 1))||'%'
            ORDER BY id_ DESC LIMIT 1;
      END IF;
      --Tarefa é de subfluxo então abre token de subfluxo e atualiza token do fluxo geral (subprocessinstance).
      --Atualizando processinstance
      UPDATE jbpm_processinstance SET superprocesstoken_ = token2G WHERE id_ = v_procinst;
      --Apontando token do fluxo geral
      UPDATE jbpm_token SET end_ = NULL , isabletoreactivateparent_ = 't', lock_ = NULL, node_ = idNodeFluxo, subprocessinstance_ = v_procinst WHERE id_ = token2G;--ok
      RAISE NOTICE 'v_id_token 3: %',v_id_token;
      RAISE NOTICE 'v_procinst 3: %',v_procinst;
    END IF;
  END IF;

  -- fechando a tarefa atual
  UPDATE jbpm_taskinstance
      SET end_ = NOW(),
          isopen_ = FALSE,
          issignalling_ = FALSE
      WHERE id_ IN (SELECT id_
                        FROM jbpm_taskinstance
                        WHERE procinst_ IN (SELECT id_proc_inst
                                                FROM tb_processo_instance
                                                WHERE id_processo = v_id_processo) AND
                              end_ IS NULL);

  -- apontando token para a tarefa destino
  UPDATE jbpm_token
      SET node_ = v_id_node,
          end_ = NULL,
          isabletoreactivateparent_ = TRUE,
          lock_ = NULL
      WHERE id_ = v_id_token;

  --Reabrindo processinstance
  UPDATE jbpm_processinstance SET end_ = NULL, issuspended_ = 'f', processdefinition_ = v_process_definition_dest WHERE id_ = v_procinst;

  -- insere a nova tarefa
  INSERT INTO jbpm_taskinstance
     (id_, class_, version_, name_, description_, actorid_, create_, start_, end_, duedate_, priority_, iscancelled_, issuspended_, isopen_, issignalling_,
 isblocking_, task_, token_, procinst_, swimlaninstance_, taskmgmtinstance_)
  VALUES
     (NEXTVAL('hibernate_sequence'), v_class, v_version, p_nome_tarefa, NULL, NULL, NOW(), NOW(), NULL, NULL, 3, FALSE, FALSE, TRUE, TRUE, FALSE, v_id_task, v_id_token, v_procinst, 
	v_swimlaninstance, v_taskmgmtinstance);

  -- Atualiza tb_processo_tarefa
  SELECT id_tarefa, ds_tarefa FROM tb_tarefa where ds_tarefa = p_nome_tarefa
  INTO v_id_tarefa, v_ds_tarefa;

  -- Deleta a localização antiga do processo.
  DELETE FROM tb_processo_tarefa WHERE id_processo_trf = v_id_processo;

  -- Insere a nova localização do processo.
  INSERT INTO tb_processo_tarefa(id_processo_trf, id_tarefa, id_task, id_processinstance, dh_criacao_tarefa, id_token, id_taskinstance, nm_tarefa)
      SELECT
          v_id_processo, v_id_tarefa, ti.task_, ti.procinst_, ti.create_, ti.token_, ti.id_, p_nome_tarefa
      FROM
          jbpm_taskinstance ti
          INNER JOIN jbpm_processinstance pi ON pi.id_ = ti.procinst_
          INNER JOIN jbpm_processdefinition pd ON pd.id_ = pi.processdefinition_
      WHERE
          ti.procinst_ IN
          (SELECT id_proc_inst FROM tb_processo_instance WHERE id_processo = v_id_processo)
      ORDER BY ti.create_ DESC
      LIMIT 1;

  -- Atualiza tb_res_escaninho
  UPDATE tb_res_escaninho SET
  nm_tarefa = v_ds_tarefa,
  id_tarefa = v_id_task
  WHERE id_processo = v_id_processo;

  /* recupera os pares localizacao/papel */
  SELECT REPLACE(REPLACE(pooledactorsexpression_, '#{localizacaoAssignment.getPooledActors(''',''), ''')}','')
      INTO v_pooledactorsexpression
      FROM jbpm_swimlane
      WHERE id_ = (SELECT swimlane_
                   FROM jbpm_swimlaneinstance
                   WHERE id_ = v_swimlaninstance);

  -- remove a visibilidade do processo
  DELETE FROM tb_proc_localizacao_ibpm
      WHERE id_processo = v_id_processo;

  -- loop pegando o par (localizacao/papel) e passando para a função retornar os valores separados
  FOREACH v_par IN ARRAY STRING_TO_ARRAY(v_pooledactorsexpression, ',') LOOP
    -- decodifica os itens do par (nnnn:nnnn)
    v_item1_par := SUBSTRING(v_par FROM 1 FOR POSITION(':' IN v_par)-1);
    v_item2_par := SUBSTRING(v_par FROM POSITION(':' IN v_par)+1);
    -- insere o par localizacao/papel
    INSERT INTO tb_proc_localizacao_ibpm
       (id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel)
    VALUES
       (v_id_task, v_procinst, v_id_processo, v_item1_par::INTEGER, v_item2_par::INTEGER);
  END LOOP;

  -- retira da caixa
  UPDATE tb_processo
      SET id_caixa = NULL
      WHERE id_processo = v_id_processo;

    --Apagar o lixo
  DELETE FROM jbpm_variableinstance WHERE processinstance_ IN
    (SELECT id_proc_inst FROM tb_processo_instance WHERE id_processo = v_id_processo)
    AND (bytearrayvalue_ IS NOT NULL OR name_ ilike '%minutaemelaboracao' OR name_ ilike '%modelo');

  -- Atualizar referencias "frameDefaultLeavingTransition:Término"
  SELECT vi.id_ INTO tempIdVI FROM jbpm_variableinstance vi,
    (SELECT id_, procinst_ FROM jbpm_taskinstance WHERE procinst_ IN
      (SELECT id_proc_inst FROM tb_processo_instance WHERE id_processo =  v_id_processo)
    AND end_ IS NULL) AS t
    WHERE vi.processinstance_ = t.procinst_ AND
  vi.name_ = 'frameDefaultLeavingTransition' AND
  vi.stringvalue_ = 'Término';

  IF NOT found THEN
    INSERT INTO jbpm_variableinstance (id_, class_, version_, name_, token_, processinstance_, stringvalue_, taskinstance_)
      VALUES( NEXTVAL('hibernate_sequence'), 'S', 0, 'frameDefaultLeavingTransition', v_id_token, v_procinst, 'Término', (SELECT id_ FROM jbpm_taskinstance WHERE procinst_ IN( SELECT id_proc_inst  FROM tb_processo_instance WHERE id_processo = v_id_processo)ORDER BY id_ DESC LIMIT 1));

  ELSE
    UPDATE jbpm_variableinstance SET taskinstance_ = t.id_ FROM
      (SELECT id_, procinst_ FROM jbpm_taskinstance WHERE procinst_ IN
        (SELECT id_proc_inst FROM tb_processo_instance WHERE id_processo = v_id_processo)
      AND end_ IS NULL) AS t
      WHERE jbpm_variableinstance.processinstance_ = t.procinst_ AND
    jbpm_variableinstance.name_ = 'frameDefaultLeavingTransition' AND
    jbpm_variableinstance.stringvalue_ = 'Término';
  END IF;

  RETURN 'Scripts aplicados com sucesso!';

END;

$$;

--Parar aqui e depois continua

-- VOLATILE;
-- CALLED ON NULL INPUT
-- SECURITY INVOKER
-- COST 100;

--=============================================================================
-- PASSO 2: Executar rotina para mover processos
--=============================================================================

    -- Sobre a sintaxe do pgsql: https://stackoverflow.com/questions/24335981/postgresql-syntax-error-at-or-near-do e https://stackoverflow.com/questions/14963144/pl-pgsql-syntax-error
	-- Executar a funcao que move os processos
DO $$

DECLARE
    p_nr_processo character varying := '0000459-45.2024.5.07.0000'; 
    p_nome_tarefa character varying := 'Análise de Gabinete';
    
BEGIN
    PERFORM public.p_ir_para_tarefa(p_nr_processo, p_nome_tarefa);
END;
$$;

--=============================================================================
-- PASSO 3: Remover função criada
--=============================================================================

    DROP FUNCTION public.p_ir_para_tarefa(p_nr_processo character varying, p_nome_tarefa character varying);
