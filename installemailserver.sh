#!/bin/bash
#Direitos autorais itwm.info.
#Desevolvido pelo Clube da Tecnologia.
#dev        :Guilherme Pacheco
#criado     :11/04/2012

#editado por: Guilherme Pacheco	
#editado    : 27/07/2012

#Script para preparação do servidor de e-mails com
#- Postfix – Servidor de Email
#- Maildrop – Entrega de Emails
#- Courier – Autenticação IMAP/POP/SMTP e Criptografia TLS
#- SASL – Conexão SMTP autenticada e criptografada
#- MySQL – Servidor de Banco de Dados (armazenamento de contas de usuários)
#- SpamAssassin – anti-spam
#- Policyd – AntiSpam
#- TMDA – AntiSpam (Opcional para as contas)

#down files for server
sudo wget https://github.com/guilhermepachecod/createemailserver/postfix.sql
sudo wget https://github.com/guilhermepachecod/createemailserver/main.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/mysql_virtual_domains_maps.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/mysql_virtual_alias_maps.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/mysql_virtual_mailbox_maps.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/mysql_virtual_mailbox_limit_maps.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/mysql_relay_domains_maps.cf
sudo wget https://github.com/guilhermepachecod/createemailserver/authdaemonrc
sudo wget https://github.com/guilhermepachecod/createemailserver/authmysqlrc
sudo wget https://github.com/guilhermepachecod/createemailserver/smtpd.conf
sudo wget https://github.com/guilhermepachecod/createemailserver/maildropmysql.conf
sudo wget https://github.com/guilhermepachecod/createemailserver/quotawarnmsg


sudo apt-get install mysql-client mysql-server mysql-common -y
sudo mysql_secure_instalation

sudo mysql --user root --password=mysqlpassword -e "CREATE USER 'mail_admin'@'localhost' IDENTIFIED BY 'mail_admin_password';"
sudo mysqladmin -u root --password=mysqlpassword create mail
sudo mysql --user root --password=mysqlpassword -e "GRANT SELECT, INSERT, UPDATE, DELETE ON mail.* TO 'mail_admin'@'localhost' IDENTIFIED BY 'mail_admin_password';"
sudo mysql --user root --password=mysqlpassword -e "GRANT SELECT, INSERT, UPDATE, DELETE ON mail.* TO 'mail_admin'@'localhost.localdomain' IDENTIFIED BY 'mail_admin_password';"

sudo mysql --user root --password=mysqlpassword -e "FLUSH PRIVILEGES;"

sudo mysql -u root --password=mysqlpassword < postfix.sql
sudo rm -f postfix.sql

sudo apt-get install postfix postfix-mysql postfix-tls

sudo cp main.cf /etc/postfix/main.cf
sudo rm -f main.cf

sudo cp mysql_virtual_domains_maps.cf /etc/postfix/mysql_virtual_domains_maps.cf
sudo cp mysql_virtual_alias_maps.cf /etc/postfix/mysql_virtual_alias_maps.cf
sudo cp mysql_virtual_mailbox_maps.cf /etc/postfix/mysql_virtual_mailbox_maps.cf
sudo cp mysql_virtual_mailbox_limit_maps.cf /etc/postfix/mysql_virtual_mailbox_limit_maps.cf
sudo cp mysql_relay_domains_maps.cf /etc/postfix/mysql_relay_domains_maps.cf

sudo rm -f mysql_virtual_domains.cf
sudo rm -f mysql_virtual_alias_maps.cf
sudo rm -f mysql_virtual_mailbox_maps.cf
sudo rm -f mysql_virtual_mailbox_limit_maps.cf
sudo rm -f mysql_relay_domains_maps.cf

sudo apt-get install courier-authdaemon courier-authmysql courier-base courier-imap courier-imap-ssl courier-pop courier-pop-ssl courier-ssl libsasl2-modules libsasl2 libsasl2-modules-sql -y

sudo cp authdaemonrc /etc/courier/authdaemonrc
sudo rm -f authdaemonrc

sudo cp authmysqlrc /etc/courier/authmysqlrc
sudo rm -f authmysqlrc

sudo cp smtpd.conf /etc/postfix/sasl/smtpd.conf
sudo rm -f smtpd.conf

sudo mkdir /var/run/authdaemond
sudo chmod 755 /var/run/authdaemond

sudo mkdir -p /var/spool/postfix/var/run/courier/authdaemon
sudo ln /var/run/courier/authdaemon/socket /var/spool/postfix/var/run/courier/authdaemon/socket
sudo chown -R daemon:daemon /var/spool/postfix/var/run/courier

sudo openssl req -new -x509 -nodes -out /etc/courier/imapd.pem -keyout /etc/courier/imapd.pem -days 365

sudo openssl req -new -x509 -nodes -out /etc/courier/pop3d.pem -keyout /etc/courier/pop3d.pem -days 365

sudo openssl req -new -x509 -nodes -out /etc/postfix/smtpd.cert -keyout /etc/postfix/smtpd.key -days 365

sudo apt-get install maildrop courier-maildrop -y

sudo cp maildropmysql.conf /etc/courier/maildropmysql.conf
sudo rm -f maildropmysql.conf

sudo cp quotawarnmsg /etc/courier/quotawarnmsg
sudo rm -f quotawarnmsg

sudo apt-get install amavisd-new spamassassin spamc razor clamav clamav-base clamav-daemon clamav-freshclam libclamav1 -y

#sudo scp /etc/amavis/amavisd.conf meuuser@192.168.1.1:/Downloads/um/amavisd.conf
#sudo scp /etc/clamav/clamd.conf meuuser@192.168.1.1:/Downloads/um/clamd.conf
#sudo scp /etc/clamav/freshclam.conf meuuser@192.168.1.1:/Downloads/um/freshclam.conf

sudo chown -R amavis:amavis /var/lib/clamav
sudo chown -R amavis:amavis /var/log/clamav
sudo chown -R amavis:amavis /var/run/clamav

#sudo scp /etc/postfix/master.cf meuuser@192.168.1.1:/Downloads/um/master.cf


#exit

