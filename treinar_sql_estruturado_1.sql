

select ds_login from pje.tb_usuario_login tul where tul.ds_nome like 'SELMA MARIA MOURA COSTA';



do $$
declare

--========================
-- PARAMETROS
--========================

    p_nr_processo varchar := '0000666-36.2023.5.07.0014';

--========================
-- VARIAVEIS
--========================

    v_id_processo integer;
    v_id_magistrado integer;
    v_id_orgao_julgador integer;
    v_id_orgao_julgador_cargo integer;
    v_id_orgao_julgador_colegiado integer;

    v_nr_processo varchar;
    v_ds_magistrado varchar;
    v_ds_orgao_julgador varchar;
    v_ds_orgao_julgador_cargo varchar;
    v_ds_orgao_julgador_colegiado varchar;
    
    -- Variaveis auxiliares
    v_record record;
    v_count int = 0;
   
begin
    
    -- Identificando processo
    select id_processo, nr_processo into v_id_processo, v_nr_processo 
    from tb_processo where nr_processo like '%' || p_nr_processo || '%';

    if v_id_processo is not null
    then
        raise info '-- Processo: % (%)', v_nr_processo, v_id_processo;
    else
        raise exception '-- Processo nao localizado!';
    end if;

    -- Identificando dados da ultima distribuicao
    select d.id_orgao_julgador, d.id_orgao_julgador_cargo, d.id_orgao_julgador_colegiado, oj.ds_orgao_julgador, ojca.ds_cargo, ojco.ds_orgao_julgador_colegiado
    into v_id_orgao_julgador, v_id_orgao_julgador_cargo, v_id_orgao_julgador_colegiado, v_ds_orgao_julgador, v_ds_orgao_julgador_cargo, v_ds_orgao_julgador_colegiado
    from tb_processo_trf_log l join tb_processo_trf_log_dist d on d.id_processo_trf_log = l.id_processo_trf_log
    join tb_orgao_julgador oj on oj.id_orgao_julgador = d.id_orgao_julgador
    join tb_orgao_julgador_cargo ojca on ojca.id_orgao_julgador_cargo = d.id_orgao_julgador_cargo
    join tb_orgao_julgador_colgiado ojco on ojco.id_orgao_julgador_colegiado = d.id_orgao_julgador_colegiado
    where l.id_processo_trf = v_id_processo order by l.id_processo_trf_log desc limit 1;


    if found then
        raise info '-- Orgao Julgador: % (%)', v_ds_orgao_julgador, v_id_orgao_julgador;
        raise info '-- Orgao Julgador Cargo: % (%)', v_ds_orgao_julgador_cargo, v_id_orgao_julgador_cargo;
        raise info '-- Orgao Julgador Colegiado: % (%)', v_ds_orgao_julgador_colegiado, v_id_orgao_julgador_colegiado;
    else
        raise exception '-- Orgao julgador cargo nao identificado!';
    end if;

    -- Identificando magistrado da ultima distribuicao
    for v_record in select ul.id_usuario, u.ds_nome 
    from tb_usu_local_mgtdo_servdor ms
    join tb_usuario_localizacao ul on ul.id_usuario_localizacao = ms.id_usu_local_mgstrado_servidor
    join tb_usuario_login u on u.id_usuario = ul.id_usuario
    join tb_localizacao l on l.id_localizacao = ul.id_localizacao
    join tb_papel p on p.id_papel = ul.id_papel
    where 1=1
    and ms.id_orgao_julgador_cargo is not null 
    -- and ms.in_magistrado_titular = 'S'
    and ms.id_orgao_julgador = v_id_orgao_julgador
    and ms.id_orgao_julgador_colegiado = v_id_orgao_julgador_colegiado
    loop 
	    
	    v_id_magistrado := v_record.id_usuario;
	    v_ds_magistrado := v_record.ds_nome;
	      	
	    if v_count > 0 then
	    	raise info '';
	    	raise info '-- OU';
	    end if;
	    v_count := v_count + 1;
	   
	    -- Atualizando magistrado relator do processo
	    raise info '';
	    raise info '-- Magistrado: % (%)', v_ds_magistrado, v_id_magistrado;
	    raise notice 'update tb_processo_trf set id_pessoa_relator_processo = % where id_processo_trf = %;', v_id_magistrado, v_id_processo;
	    -- update tb_processo_trf set id_pessoa_relator_processo  = v_id_magistrado where id_processo_trf = v_id_processo;
   
    end loop;

    if v_count > 1 then
    	raise info '';
    	raise info '-- AVISO: Execute apenas um dos updates acima, pois ha mais de um magistrado no gabinete.';
    end if;
   
    if v_count = 0 then
         raise exception '-- Magistrado nao identificado!';
    end if;

end $$ language plpgsql;