------------------------------------------------
-- Processo: 0007544-53.2022.5.07.0000 (115006)
------------------------------------------------
do $PROC115006$
declare
    var_id_processo_evento bigint := nextval('sq_tb_processo_evento');
begin

    -- Inserir movimento: 'Julgado(s) procedente(s) o(s) pedido(s) (#{classe processual}/ #{nome do incidente}) de #{nome da parte}'
    insert into pje.tb_processo_evento (id_processo_evento, id_processo, id_evento, dt_atualizacao, in_processado, in_verificado_processado,
				 tp_processo_evento, ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
    values (var_id_processo_evento, 115006, 219, '2024-04-13 17:58:52.058169', 'N', 'N', 'M',
		 'Julgado(s) procedente(s) o(s) pedido(s) (#{classe processual}/ #{nome do incidente}) de #{nome da parte}',
		 'Julgado(s) procedente(s) o(s) pedido(s) (#{classe processual}/ #{nome do incidente}) de #{nome da parte}', true,
		 'Julgado(s) procedente(s) o(s) pedido(s) (#{classe processual}/ #{nome do incidente}) de #{nome da parte}');

    ------------

    -- Inserir complemento: 'nome da parte' = 'NORIVAL RIBEIRO DUTRA - CPF: 135.743.969-53' [764594]
    insert into pje.tb_complemento_segmentado (vl_ordem,ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento,
				 in_visibilidade_externa, in_multivalorado)
    values (0, '764594', 'NORIVAL RIBEIRO DUTRA - CPF: 135.743.969-53', var_id_processo_evento, 13, true, false);

    -- Substituir complemento no texto: 'nome da parte' = 'NORIVAL RIBEIRO DUTRA - CPF: 135.743.969-53'
    update pje.tb_processo_evento set ds_texto_final_externo = replace(ds_texto_final_externo, '#{nome da parte}',
			 'NORIVAL RIBEIRO DUTRA - CPF: 135.743.969-53') where id_processo_evento = var_id_processo_evento;

    ------------

    -- Inserir complemento: 'classe processual' = 'AÃ‡ÃƒO RESCISÃ“RIA (47)' [231]
    insert into pje.tb_complemento_segmentado (vl_ordem,ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento,
				 in_visibilidade_externa, in_multivalorado)
    values (0, '231', 'AÃ‡ÃƒO RESCISÃ“RIA (47)', var_id_processo_evento, 63, true, false);

    -- Substituir complemento no texto: 'classe processual' = 'AÃ‡ÃƒO RESCISÃ“RIA (47)'
    update pje.tb_processo_evento set ds_texto_final_externo = replace(ds_texto_final_externo, '#{classe processual}',
				 'AÃ‡ÃƒO RESCISÃ“RIA (47)') where id_processo_evento = var_id_processo_evento;

    ------------

    -- Inserir complemento: 'nome do incidente' = '' []
    insert into pje.tb_complemento_segmentado (vl_ordem,ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento,
				 in_visibilidade_externa, in_multivalorado)
    values (0, '', '', var_id_processo_evento, 37, true, false);

    -- Substituir complemento no texto: 'nome do incidente' = ''
    update pje.tb_processo_evento set ds_texto_final_externo = replace(ds_texto_final_externo, '#{nome do incidente}', '') 
	where id_processo_evento = var_id_processo_evento;

    ------------

    -- Finalizar movimento
    update pje.tb_processo_evento set ds_texto_final_interno = ds_texto_final_externo where id_processo_evento = var_id_processo_evento;

end $PROC115006$ language plpgsql;
