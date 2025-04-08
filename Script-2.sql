
select 
    tpt.id_processo_trf ,
    tpt.id_orgao_julgador ,
    tpt.id_orgao_julgador_cargo ,
    tps.id_orgao_julgador_redator ,
    tps.id_pauta_sessao ,
    tcs.id_composicao_sessao,
    tps.id_sessao ,
    toj.ds_orgao_julgador 
from pje.tb_processo_trf tpt inner join pje.tb_processo tp
on tpt.id_processo_trf = tp.id_processo inner join pje.tb_orgao_julgador toj
on tpt.id_orgao_julgador = toj.id_orgao_julgador inner join pje.tb_orgao_julgador_cargo tojc
on tpt.id_orgao_julgador_cargo = tojc.id_orgao_julgador_cargo inner join pje_jt.tb_pauta_sessao tps
on tpt.id_processo_trf = tps.id_processo_trf inner join pje_jt.tb_composicao_sessao tcs
on tpt.id_orgao_julgador = tcs.id_orgao_julgador where tp.nr_processo like '0001495-25.2024.5.07.0000';

select * from pje.tb_usuario_login tul where tul.id_usuario = 9;



-- Informar abaixo
do $$
declare

--============
-- PARAMETROS
--============

p_id_sessao integer := 8345;
p_ds_orgao_julgador varchar := 'Gab. Des. Paulo Régis Machado Botelho';
p_nome_magistrado varchar := 'PAULO REGIS MACHADO BOTELHO%';
p_ds_cargo varchar := 'Desembargador%'; -- se der erro, tentar 'Juiz%'

-- Liste os processos neste array
p_nr_processo_array varchar[] := ARRAY[
	'0001495-25.2024.5.07.0000'
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
	
	-- Procurar o orgao julgador colegiado
	select x.id_orgao_julgador_colegiado, x.ds_orgao_julgador_colegiado, 
			c.id_orgao_julgador_cargo, c.ds_cargo 
--	       case when x.id_orgao_julgador_colegiado = 9 then 'Pleno' else 'Turma' end tp_orgao_julgador_colegiado
	into v_id_orgao_julgador_colegiado, v_ds_orgao_julgador_colegiado, 
			v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo
--	v_tp_orgao_julgador_colegiado
	from tb_processo_trf y
	join tb_orgao_julgador_colgiado x on y.id_orgao_julgador_colegiado = x.id_orgao_julgador_colegiado
	join tb_orgao_julgador_cargo c on c.id_orgao_julgador_cargo = y.id_orgao_julgador_cargo 
	where y.id_processo_trf = v_id_processo;
	
	
	if coalesce(v_id_orgao_julgador_colegiado, 0) <> 0
	then
		raise notice '-- Colegiado: % (%)', v_id_orgao_julgador_colegiado, v_ds_orgao_julgador_colegiado;
	else
		raise exception 'Colegiado nao localizado!';
	end if;
	
	-- Procurar cargo de distribuicao do orgao julgador
	select c.id_orgao_julgador_cargo, c.ds_cargo
	into v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo
	from tb_orgao_julgador_cargo c
	join tb_usu_local_mgtdo_servdor u on u.id_orgao_julgador_cargo = c.id_orgao_julgador_cargo and u.id_orgao_julgador = c.id_orgao_julgador
	join tb_cargo cargo on cargo.id_cargo = c.id_cargo
	where c.id_orgao_julgador = v_id_orgao_julgador
	and u.id_orgao_julgador_colegiado = v_id_orgao_julgador_colegiado
	and cargo.ds_cargo ilike p_ds_cargo
	and c.in_ativo = 'S' and u.dt_final is null;
	
	if coalesce(v_id_orgao_julgador_cargo, 0) <> 0
	then
		raise notice '-- Cargo de distribuicao: % (%)', v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo;
	else
		raise exception 'Cargo de distribuicao nao localizado!';
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

end $$ language plpgsql;




update tb_pauta_sessao set id_orgao_julgador_redator = 66, id_magistrado_redator = 9 where id_pauta_sessao = 216422;
update tb_processo_trf set id_orgao_julgador = 66, id_orgao_julgador_cargo = 146 where id_processo_trf = 150243;
update pje_jt.tb_composicao_sessao set id_magistrado_presente = 9 where id_composicao_sessao = 34820 and id_sessao = 8345;







