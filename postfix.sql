USE mail;
CREATE TABLE domains (
domain varchar(50) NOT NULL,
PRIMARY KEY (domain) )
TYPE=MyISAM;

CREATE TABLE forwardings (
source varchar(80) NOT NULL,
destination TEXT NOT NULL,
PRIMARY KEY (source) )
TYPE=MyISAM;

CREATE TABLE users (
email varchar(80) NOT NULL,
password varchar(20) NOT NULL,
quota INT(10) DEFAULT '10485760',
PRIMARY KEY (email)
) TYPE=MyISAM;

CREATE TABLE transport (
domain varchar(128) NOT NULL default '',
transport varchar(128) NOT NULL default '',
UNIQUE KEY domain (domain)
) TYPE=MyISAM;

INSERT INTO `domains` (`domain`) VALUES ('meudominio.com.br');
INSERT INTO `users` (`email`, `password`, `quota`) VALUES ('meuemail@meudominio.com.br', ENCRYPT('meuencryptpassword'), 10485760);
INSERT INTO `domains` (`domain`) VALUES ('outrodominio.com.br');
INSERT INTO `users` (`email`, `password`, `quota`) VALUES ('outroemail@outrodominio.com.br', ENCRYPT('meuencryptpassword'), 10485760);
