-- sessao: 2024-10-03, processo: 0000259-04.2021.5.07.0013
UPDATE tb_pauta_sessao SET id_tipo_situacao_pauta=7 WHERE id_pauta_sessao=223703;

---------------------------------------------------------------
-- Inicio do script
---------------------------------------------------------------
-- PROCESSO
--    Numero:               128034 - 0000259-04.2021.5.07.0013
--    Orgao julgador:       46 - Gab. Des. JosÃ© Antonio Parente da Silva
--    Orgao colegiado:      10 - 3Âª Turma
-- TAREFA DE ORIGEM
--    Process definition:   14739090 - Controle de sessÃ£o
--    Process instance:     24121277
--    Token:                24121278
--    Module Instance:      24121280
--    Swimlane instance:    24121289
--    Task node:            14739177 - Assinar acÃ³rdÃ£o
--    Task definition:      14739182 - Assinar acÃ³rdÃ£o
--    Task instance:        24335713 - Assinar acÃ³rdÃ£o
-- TAREFA DE DESTINO
--    Process definition:   14739090 - Controle de sessÃ£o
--    Process instance:     24121277
--    Token:                24121278
--    Module Instance:      24121280
--    Swimlane instance:    24121289
--    Task node:            14739125 - Aguardando inclusÃ£o em pauta ou sessÃ£o
--    Task definition:      14739130 - Aguardando inclusÃ£o em pauta ou sessÃ£o
--    Task instance:        NOVA
---------------------------------------------------------------
do $PROC128034$
declare 
    var_id_taskinst integer;
begin

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Verificar se o processo estÃ¡ na tarefa esperada
if (select 1 from pje_jbpm.jbpm_taskinstance x where x.end_ is null and x.id_ = 24335713) is null then
raise exception 'O processo nÃ£o esta mais na tarefa em que ele estava quando este script foi gerado.';
end if;

-- Verificar mais uma vez se o processo estÃ¡ na tarefa esperada
if (select 1 from tb_processo_tarefa x where x.id_processo_trf = 128034 and x.id_taskinstance = 24335713) is null then
raise exception 'O processo nÃ£o esta mais na tarefa em que ele estava quando este script foi gerado.';
end if;
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- CASO 4: A origem e o destino sao do mesmo SUBFLUXO

-- Atualizar token da instancia do SUBFLUXO 'Controle de sessÃ£o' (24121278)
update jbpm_token set node_ = 14739125, subprocessinstance_ = null where id_ = 24121278;

-- Fechar a instancia de tarefa de origem 'Assinar acÃ³rdÃ£o' (24335713)
update jbpm_taskinstance set end_ = current_timestamp, isopen_ = false, issignalling_ = false where end_ is null and id_ = 24335713;

-- Criar uma instancia de tarefa de destino 'Aguardando inclusÃ£o em pauta ou sessÃ£o' (14739130)
select nextval('hibernate_sequence') into var_id_taskinst;
insert into jbpm_taskinstance(id_,class_,version_,name_,create_,priority_,iscancelled_, issuspended_,isopen_,issignalling_,isblocking_,task_, token_,procinst_,swimlaninstance_,taskmgmtinstance_)
	values(var_id_taskinst, 'T', 9, 'Aguardando inclusÃ£o em pauta ou sessÃ£o', current_timestamp, 3, false, false, true, true, false, 14739130, 24121278, 24121277, 24121289, 24121280);

-- Atualizar a tabela TB_PROC_LOCALIZACAO_IBPM
delete from tb_proc_localizacao_ibpm where id_processo = 128034 and id_processinstance_jbpm = 24121277;
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 3, 5132);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 3, 5133);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 3, 5197);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 4, 1469);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 6, 1338);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 6, 5031);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 6, 5188);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 6, 5483);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 2573, 5132);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 2573, 5133);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 2573, 5197);
insert into tb_proc_localizacao_ibpm(id_task_jbpm, id_processinstance_jbpm, id_processo, id_localizacao, id_papel) values (14739130, 24121277, 128034, 2574, 1469);

-- Atualizar a tabela TB_PROCESSO_TAREFA
delete from tb_processo_tarefa where id_processo_trf = 128034 and id_processinstance = 24121277;
insert into tb_processo_tarefa (id_processo_tarefa, id_processo_trf, id_tarefa, id_task, id_processinstance, dh_criacao_tarefa, id_token, id_taskinstance, nm_tarefa)
	values (nextval('sq_tb_processo_tarefa'), 128034, 146, 14739130, 24121277, current_timestamp, 24121278, var_id_taskinst, 'Aguardando inclusÃ£o em pauta ou sessÃ£o');

-- Atualizar a tabela TB_RES_ESCANINHO
UPDATE tb_res_escaninho set nm_tarefa = 'Aguardando inclusÃ£o em pauta ou sessÃ£o', id_tarefa = 14739130 WHERE id_processo = 128034;

-- Inserir variavel de fluxo 'frameDefaultLeavingTransition' = 'Retorno para gabinete'
delete from jbpm_variableinstance where name_ = 'frameDefaultLeavingTransition' and token_ = 24121278 and processinstance_ = 24121277;
insert into jbpm_variableinstance (id_, class_, version_, name_, token_, processinstance_, stringvalue_, taskinstance_)
	values (nextval('hibernate_sequence'), 'S', 0, 'frameDefaultLeavingTransition', 24121278, 24121277, 'Retorno para gabinete', var_id_taskinst);

-- Excluir algumas variaveis problematicas
delete from jbpm_variableinstance where processinstance_ in (select id_proc_inst from tb_processo_instance where id_processo = 128034) and
	(bytearrayvalue_ is not null or name_ ilike '%minutaemelaboracao' or name_ ilike '%minutaarquivamento' or name_ ilike '%modelo');

-- Retirar o processo de caixa
update tb_processo set id_caixa = null where id_caixa is not null and id_processo = 128034;

end $PROC128034$ language plpgsql;
---------------------------------------------------------------
-- Fim do script
---------------------------------------------------------------

------------------------------------------------
-- Processo: 0000259-04.2021.5.07.0013 (128034)
------------------------------------------------
do $PROC128034$
declare
    var_id_processo_evento bigint := nextval('sq_tb_processo_evento');
begin

    -- Inserir movimento: 'Deliberado em sessÃ£o (#{tipo de deliberaÃ§Ã£o})'
    insert into pje.tb_processo_evento (id_processo_evento, id_processo, id_evento, dt_atualizacao, in_processado, in_verificado_processado, tp_processo_evento, ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
    values (var_id_processo_evento, 128034, 873, '2024-10-14 09:25:45.07', 'N', 'N', 'M', 'Deliberado em sessÃ£o (#{tipo de deliberaÃ§Ã£o})', 'Deliberado em sessÃ£o (#{tipo de deliberaÃ§Ã£o})', true, 'Deliberado em sessÃ£o (#{tipo de deliberaÃ§Ã£o})');

    ------------

    -- Inserir complemento: 'tipo de deliberaÃ§Ã£o' = 'adiado o julgamento' [7198]
    insert into pje.tb_complemento_segmentado (vl_ordem,ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado)
    values (0, '7198', 'adiado o julgamento', var_id_processo_evento, 52, true, false);

    -- Substituir complemento no texto: 'tipo de deliberaÃ§Ã£o' = 'adiado o julgamento'
    update pje.tb_processo_evento set ds_texto_final_externo = replace(ds_texto_final_externo, '#{tipo de deliberaÃ§Ã£o}', 'adiado o julgamento') where id_processo_evento = var_id_processo_evento;

    ------------

    -- Finalizar movimento
    update pje.tb_processo_evento set ds_texto_final_interno = ds_texto_final_externo where id_processo_evento = var_id_processo_evento;

end $PROC128034$ language plpgsql;
---------------------------------------------------------------
-- Fim do script
---------------------------------------------------------------







































