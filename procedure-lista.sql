-- 1
/*

delimiter $$

create procedure sp_aumento_salario(
	in id_func int,
	in taxa int,
	out mensagem varchar(255)
)
begin
	declare funcionario_existe int;
    select count(*) into funcionario_existe from funcionario as f where f.id_func = id_func;
    
    if funcionario_existe > 0 then
		update funcionario as f set salario = salario * taxa where f.id_func = id_func;
        set mensagem = concat('Salario do funcionario', id_func, ' atualizado com sucesso.');
	else
		set mensagem = concat('Funcionario', id_func, ' nao encontrado.');
    end if;
end $$

delimiter ;

*/

delimiter $$

set @id_func = 1;
set @taxa = 1.2;
set @mensagem = '';

call sp_aumento_salario(@id_func, @taxa, @mensagem);
select @mensagem;

delimiter ;
