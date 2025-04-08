

select id_usuario , ds_nome, ds_login from pje.tb_usuario_login tul where tul.ds_nome like 'NELSON ESCOSSIA BARBOSA NETO%';

select 
	t2.ds_email ,
	tl.id_localizacao ,
	tl.ds_localizacao ,
	tp.id_papel ,
	tp.ds_nome as papel
from pje.tb_usuario_localizacao t1 inner join pje.tb_usuario_login t2
on t1.id_usuario = t2.id_usuario inner join pje.tb_localizacao tl 
on t1.id_localizacao = tl.id_localizacao inner join pje.tb_papel tp 
on t1.id_papel = tp.id_papel where t2.id_usuario = (select id_usuario from pje.tb_usuario_login tul where tul.id_usuario = 1323);

select * from pje.tb_orgao_julgador_cargo tojc;
select * from pje.tb_orgao_julgador toj ;

/*do $$
declare 
    v_id_usuario integer;
begin
    -- Seleciona o id_usuario baseado no nome
    select id_usuario
    into v_id_usuario
    from pje.tb_usuario_login tul
    where tul.ds_nome like 'JOAO CARLOS DE OLIVEIRA UCHOA%';

    select 
	t2.ds_email ,
	tl.id_localizacao ,
	tl.ds_localizacao ,
	tp.id_papel ,
	tp.ds_nome as papel
from pje.tb_usuario_localizacao t1 inner join pje.tb_usuario_login t2
on t1.id_usuario = t2.id_usuario inner join pje.tb_localizacao tl 
on t1.id_localizacao = tl.id_localizacao inner join pje.tb_papel tp 
on t1.id_papel = tp.id_papel where t2.id_usuario = v_id_usuario;



end $$ language plpgsql;*/