#创建数据库
Create schema mydb;

#选择数据库
use mydb;

#创建表
create table students
(
	id int unsigned not null auto_increment primary key,
	name char(8) not null,
	sex char(4) not null,
	age tinyint unsigned not null,
	tel char(13) null default "-"
);

create table skill
(
	id int unsigned not null primary key auto_increment,
    name varchar(10) not null,
    attackrange float unsigned not null,
    damage float unsigned not null,
    cd float unsigned not null,
    unique index name_unique (name asc)
);

create table pet
(
	id int unsigned not null primary key,
    name varchar(20) not null,
    owner varchar(20) default "-",
    spacies varchar(20) default "-",
    sex char(1) not null,
    birth date,
    death date,
    unique index name_unique (name asc)
);

create table test
(
	id int unsigned not null primary key auto_increment,
    name varchar(20) not null,
    adress varchar(50) null default "-",
    unique index name_unique (name asc)
);

#改变字段类型
alter table pet change column id id int(20) unsigned not null auto_increment;

#显示pet表
select * from pet;

#插入数据
insert students (name, sex, age, tel) values ("gaoheng", "true", 25, "18717747584");
insert students (name, sex, age) values ("曹操", "true", 20);
insert students (name, sex, age) values ("周瑜", "true", 17);
insert students (name, sex, age) values ("小乔", "false", 18);
insert students (name, sex, age) values ("许诸", "true", 22);
insert students (name, sex, age) values ("陈咬金", "true", 30);
insert students (name, sex, age) values ("张_", "true", 23);
insert students (name, sex, age) values ("赵云", "true", 23);
insert students (name, sex, age) values ("董卓", "true", 23);
insert students (name, sex, age, tel) values ("吕布", "true", 22, "110");
insert students values (null, "诸葛亮", "true", 20, "-");

#显示student表
select * from students;

#只显示name，age列
select name, age from students;

#条件查找，可使用 > >= < <= = != and or like not like
select * from students where name = "gaoheng" and sex = "true";

#更新表
update students	set tel = default where id = 4;
update students set age = age + 1;
update students set tel = default where id = 3;
update students set createtime = null;
update students set name = "袁绍", age = "25" where tel = "18717747584";

#删除一条数据
delete from students where name = "诸葛亮";
delete from students where id = 13;

#添加一列数据
alter table students add birthday timestamp after age;
alter table students add adress char(40) not null default "-";
alter table students add adress char(40);

#删除一列数据
alter table students drop adress;

#修改字段名称
alter table students change tel phone char(13);

#修改字段类型，还可用change column来修改
alter table students change createtime createtime timestamp;

#如果包含test表就删除它
drop table if exists test;

#数据库版本， 当前时间
select version(), current_date();

#MySQL函数
select sin(pi() / 4), pow(2, 6);

#显示当前用户和各种格式的时间
select current_user(), current_time(), current_date(), current_timestamp(), now();

#查看所有用户
select user();

#用本地的.txt文件填充表，数据之间默认用tab分割。lines terminated by '\r\n'（指定数据分隔符和单行结束符）
load data local infile "C:/Users/Administrator/Desktop/pet.txt" into table pet;

#删除pet表中所有数据
delete from pet;

#查看字段类型
describe pet;

#检索整个表
select * from pet;

#有条件的检索
select * from pet where name = "Fluffy";

#通过生日检索数据
select * from pet where birth > "1993-9-11";

#检索特殊列
select name, birth from pet where birth > "1993-9-11";

#只检索owner列
select owner from pet;

#去除重复的名字
select distinct owner from pet;

#对数据进行排序(升序) 注：asc关键字仅作用于它前面的列名, 默认是升序，可省略asc关键字
select name, birth from pet order by birth asc;
#对数据进行排序(降序) 注：desc关键字仅作用于它前面的列名
select name, birth from pet order by birth desc;
#计算年龄并按年龄排序
select name, birth, curdate(), (year(curdate()) - year(birth)) - (right(curdate(), 5) < right(birth, 5)) as age from pet order by age;
#提取日期中的年、月、日
select name, year(birth) as year, month(birth) as month, dayofmonth(birth) as day from pet;

#显示当前月的下个月
select month(date_add(curdate(), interval 1 month));
select date_add(curdate(), interval 1 month);

#求余函数
select MOD(0, 12);

#0和null为假，其余为真
select 0 is null, 0 is not null, '' is null, '' is not null;

#"_"匹配任何单个字符，"%"匹配任意个字符, MySQL默认忽略大小写
#查找以b开头的名字
select name from pet where name like "b%";

#找出名字正好是五个字符的数据
select name from pet where name like "_____";

#正则表达式语法-------------rlike, not rlike	regexp, not regexp
#查找以b开头的数据
select * from pet where name rlike "^b";

#count(*)用于计算这个字段在整个表中出现了多少次
SELECT owner, COUNT(*), birth FROM pet GROUP BY owner;
select spacies, sex, COUNT(*) from pet group by spacies asc;
select * from pet;