

-------------------------------    Comandos adicionais    ------------------------------------


-- separar os campos de uma data
select 
	tpd.dt_juntada ,
	extract (day from tpd.dt_juntada) as dia,
	extract (month from tpd.dt_juntada) as mes,
	extract (year from tpd.dt_juntada) as ano
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where tp.nr_processo = '0000424-76.2024.5.07.0003';


-- retornar caracteres especificos de uma string
select 
	ds_login, 
	substring(ds_login from 1 for 5), -- retorna somente os caracteres do 1 ao 5
	substring(ds_login, 2) -- retorna a string sem os dois primeiros caracteres
from pje.tb_usuario_login tul where tul.ds_nome = 'ANA PAULA LOPES DUARTE';


-- retornar todos os caracteres maiusculos
select 
	ds_email,
	upper(ds_email)
from pje.tb_usuario_login tul where tul.ds_login = '80395643368';


-- é possivel informar mensagem sobre um campo null, explicando o possivel motivo de está nulo.
select 
	tpd.in_ativo ,
	tpd.ds_motivo_exclusao ,
	coalesce(tpd.ds_motivo_exclusao, 'Documento não excluido')
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where nr_processo = '0000424-76.2024.5.07.0003';


-- comando case
select 
	case tpd.in_ativo
		when 'S' then 'SIM'
		when 'N' then 'NAO'
		else 'Outros'
		end as tb_processo_documento 
from pje.tb_processo_documento tpd inner join pje.tb_processo tp 
on tpd.id_processo = tp.id_processo where nr_processo = '0000424-76.2024.5.07.0003';























