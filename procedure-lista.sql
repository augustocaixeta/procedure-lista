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
        set mensagem = concat('Salario do funcionario ', id_func, ' atualizado com sucesso.');
    else
        set mensagem = concat('Funcionario ', id_func, ' nao encontrado.');
    end if;
end $$

delimiter ;

-- Testes
set @id_func = 1;
set @taxa = 1.2;
set @mensagem = '';

call sp_aumento_salario(@id_func, @taxa, @mensagem);
select @mensagem;

-- 2
drop table if exists hora_extra;
drop procedure if exists sp_calcular_hora_extra;
drop trigger if exists trg_adicionar_hora_extra;

create table hora_extra (
    id_func int primary key,
        constraint fk_hora_extra_funcionario foreign key(id_func) references funcionario(id_func)
        on delete cascade on update cascade,
    horas_excedidas decimal(6,1) not null
);

delimiter $$

create procedure sp_calcular_hora_extra(in p_id_func int)
begin
    declare total_horas decimal(6,1);
    declare horas_excedidas decimal(6,1);

    select sum(num_horas) into total_horas from trabalha where id_func = p_id_func;

    if total_horas > 40.0 then
        set horas_excedidas = total_horas - 40.0;
        insert into hora_extra(id_func, horas_excedidas) values (p_id_func, horas_excedidas)
        on duplicate key update horas_excedidas = values(horas_excedidas);
    end if;
end $$

create trigger trg_adicionar_hora_extra before insert on trabalha
for each row
begin
    call sp_calcular_hora_extra(new.id_func);
end $$

delimiter ;

-- Testes
insert into trabalha(id_func, id_proj, num_horas) values (8, 20, 60.0) on duplicate key update num_horas = values(num_horas);
