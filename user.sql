create table user
(
	id int unsigned not null primary key auto_increment,
    username varchar(20) not null,
    password varchar(20) not null,
    unique index username_unique(username asc)
);