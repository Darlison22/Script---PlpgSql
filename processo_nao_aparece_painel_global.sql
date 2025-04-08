

select ds_login from pje.tb_usuario_login tul where ds_nome like 'MARJA DE OLIVEIRA ESTITE';

select * from pje.tb_processo tp where nr_processo like '0000548-44.2024.5.07.0008';


----------------------------------------------------------------------------------------------

select * from pje.tb_tmp_documento_assinando ttda where id_processo_trf = 
(select id_processo from tb_processo where nr_processo like '0001213-82.2024.5.07.0033');

select nr_processo from pje.tb_processo where id_processo = 798821;


delete
from tb_tmp_documento_assinando
where id_processo_trf = (select id_processo from tb_processo where nr_processo = '0001213-82.2024.5.07.0033');

select  *from pje.tb_tmp_documento_assinando ttda ;


------------------------------------------------------------------------------------------------------

select * from pje.tb_tmp_documento_assinando ttda 
where ttda.id_processo_trf  in (
select id_processo from pje.tb_processo 
where nr_processo 
in(
'0001262-26.2024.5.07.0033',
'0001062-19.2024.5.07.0033',
'0001064-86.2024.5.07.0033',
'0001066-56.2024.5.07.0033',
'0001065-71.2024.5.07.0033',
'0001067-41.2024.5.07.0033',
'0001176-55.2024.5.07.0033',
'0001186-02.2024.5.07.0033',
'0001236-28.2024.5.07.0033',
'0001190-39.2024.5.07.0033'
));