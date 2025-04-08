-- Informar abaixo
do $$
declare

--============
-- PARAMETROS
--============

p_id_sessao integer := 8228;
p_ds_orgao_julgador varchar := 'PAULO R%';
p_nome_magistrado varchar := 'ROSA DE LOURDES AZ%';
p_ds_cargo varchar := 'Desembargador%'; -- se der erro, tentar 'Juiz%'

-- Liste os processos neste array
p_nr_processo_array varchar[] := ARRAY[
	'0000099-96.2024.5.07.0037',
'0000279-45.2024.5.07.0027',
'0000335-48.2024.5.07.0037',
'0000346-07.2024.5.07.0028',
'0000349-62.2024.5.07.0027',
'0000369-53.2024.5.07.0027',
'0000370-38.2024.5.07.0027',
'0000416-24.2024.5.07.0028',
'0000418-94.2024.5.07.0027',
'0000430-08.2024.5.07.0028',
'0000440-55.2024.5.07.0027',
'0000508-05.2024.5.07.0027',
'0000547-02.2024.5.07.0027',
'0000572-15.2024.5.07.0027'
];

--============
-- VARIAVEIS
--============

v_id_pauta_sessao integer;
v_padrao_nome_magistrado varchar;

v_id_processo integer;
v_nr_processo varchar;

v_id_usuario_magistrado integer;
v_nm_usuario_magistrado varchar;

v_id_orgao_julgador integer;
v_ds_orgao_julgador varchar;
v_padrao_ds_orgao_julgador varchar;

v_id_cargo integer;
v_id_orgao_julgador_cargo integer;
v_ds_orgao_julgador_cargo varchar;

v_id_orgao_julgador_colegiado integer;
v_ds_orgao_julgador_colegiado varchar;
v_tp_orgao_julgador_colegiado varchar;

v_id_composicao_sessao integer;

begin

-- Gerar padrao de consulta por nome do magistrado informado
select '%' || lower(to_ascii(replace(p_nome_magistrado, ' ', '%'))) || '%' into v_padrao_nome_magistrado;

-- Gerar padrao de consulta por descricao do orgao julgador informado
select '%' || lower(to_ascii(replace(p_ds_orgao_julgador, ' ', '%'))) || '%' into v_padrao_ds_orgao_julgador;

raise notice '--------------------------------------------------- INICIO ----------------------------------------------';

foreach v_nr_processo in array p_nr_processo_array loop

	-- Procurar processo
	select id_processo into v_id_processo
	from tb_processo where nr_processo = v_nr_processo;
	
	if coalesce(v_id_processo, 0) <> 0
	then
		raise notice '-- Processo: % (%)', v_nr_processo, v_id_processo;
	else 
		raise exception 'Processo nao localizado!';
	end if;
	
	-- Procurar pauta em que o processo esta
	select id_pauta_sessao
	into v_id_pauta_sessao
	from tb_pauta_sessao
	where id_processo_trf = v_id_processo
	and id_sessao = p_id_sessao;
	
	if coalesce(v_id_pauta_sessao, 0) <> 0
	then
		raise notice '-- Pauta: %', v_id_pauta_sessao;
	else
		raise exception 'Pauta nao localizada!';
	end if;
	
	-- Procurar usuario do magistrado
	select u.id_usuario, u.ds_nome
	into v_id_usuario_magistrado, v_nm_usuario_magistrado
	from tb_usuario_login u
	join tb_pessoa_magistrado m on m.id = u.id_usuario
	where lower(to_ascii(ds_nome)) like v_padrao_nome_magistrado;
	
	if coalesce(v_id_usuario_magistrado, 0) <> 0
	then
		raise notice '-- Usuario do magistrado: % (%)', v_nm_usuario_magistrado, v_id_usuario_magistrado;
	else
		raise exception 'Usuario do magistrado nao localizado!';
	end if;
	
	-- Procurar orgao julgador do magistrado
	select id_orgao_julgador, ds_orgao_julgador
	into v_id_orgao_julgador, v_ds_orgao_julgador
	from tb_orgao_julgador 
	where lower(to_ascii(ds_orgao_julgador)) like v_padrao_ds_orgao_julgador
	  and in_ativo = 'S';
	
	if coalesce(v_id_orgao_julgador, 0) <> 0
	then
		raise notice '-- Orgao Julgador: % (%)', v_ds_orgao_julgador, v_id_orgao_julgador;
	else
		raise exception 'Orgao julgador nao localizado!';
	end if;
	

	-- Procurar o registro nas tabelas de composicao
	-- cs.id_magistrado_presente
	select cs.id_composicao_sessao
	into v_id_composicao_sessao
	from pje_jt.tb_composicao_sessao cs 
	join pje_jt.tb_composicao_proc_sessao cps on cps.id_composicao_sessao = cs.id_composicao_sessao
	where 1=1
	and cs.id_sessao = p_id_sessao
	and cs.id_orgao_julgador = v_id_orgao_julgador
	and cps.id_pauta_sessao = v_id_pauta_sessao;

	if coalesce(v_id_composicao_sessao, 0) <> 0
	then
		raise notice '-- ID na composicao: %', v_id_composicao_sessao;
	else
		raise exception 'ID na composicao nao localizado!';
	end if;
	
	raise notice 'update tb_pauta_sessao set id_orgao_julgador_redator = %, id_magistrado_redator = % where id_pauta_sessao = %;', v_id_orgao_julgador, v_id_usuario_magistrado, v_id_pauta_sessao;
	raise notice 'update tb_processo_trf set id_orgao_julgador = %, id_orgao_julgador_cargo = % where id_processo_trf = %;', v_id_orgao_julgador, v_id_orgao_julgador_cargo, v_id_processo;
	raise notice 'update pje_jt.tb_composicao_sessao set id_magistrado_presente = % where id_composicao_sessao = % and id_sessao = %;', v_id_usuario_magistrado, v_id_composicao_sessao, p_id_sessao;
	raise notice '';
end loop;

raise notice '-------------------------------------------------- FIM ---------------------------------------------------';

end $$ language plpgsql;