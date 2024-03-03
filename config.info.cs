avail_mail=Virtualni email (pro postovni schranky a aliasy)1,1-Ano,0-Ne
quotas=Omezeni Quota pro domeny a postovni uzivatele?,1,1-Ano (je-li dostupne),0-Ne
avail_custom=Vlastni prikazy,1,1-Ano,0-Ne
ldap_base=Zakladna pro postovni uzivatele,0
show_features=Zobrazit doplnky serveru na titulni strane?,1,1-Ano,0-Ne
dns_ip=Vyvhozi IP adresa pro zaznamy DNS,3,Stejne jako IP virtualniho serveru
bccs=Povolit nastaveni automaticke slepe kopie odchozi posty?,1,1-Ano,0-Ne
cert_tmpl=Vzor pro cestu k certifikatu,3,Vychozi (<tt>~/ssl.cert</tt>)
line1.5=Prava administratoru serveru,11
mail_system=Nastaveny postovni server,4,1-Sendmail,0-Postfix,2-QMail,4-QMail+LDAP,5-QMail+VPOPMail,6-Exim (experimental),3-Detekuj automaticky
avail_change-user=Zmenit jazyk a motiv,1,1-Ano,0-Ne
avail_updown=Upload a Download,1,1-Ano,0-Ne
line4=Akce po vytvoreni serveru a uzivatelu,11
edit_quota=Muze nastavovat omezeni Quota postovnich schranek?,1,1-Ano,0-Ne
allow_subdoms=Povolit vytvareni sub-domen?,1,1-Ano,0-Ne,-Urcit automaticky
webmin_modules=Extra moduly Webminu pro administratory serveru,15,modules,webmin_modules
allow_upper=Vzdy uvadet nazvy postovnich uzivatelskych uctu malymi pismeny?,1,0-Ano,1-Ne
iface_base=Zakladni cislo pro virtualni rozhranni,3,Automaticky
show_mailsize=Zobrazit velikost postovnich schranek v seznamu uzivatelu?,1,1-Ano,0-Ne
avail_at=Naplanovane ulohy,1,1-Ano,0-Ne
warnbw_template=Soubor se vzorem emailu serverum&#44; kterym se blizi limit vytizeni,10,default-Vychozi
vpopmail_group=Skupina VPOPMail,6
key_size=Vychozi velikost klice SSL,3,Vychozi dle Webminu (512 bitu),6,,bitu
ldap=Ukladat uzivatele a skupiny,1,1-V adresari LDAP,0-V lokalnich souborech
homes_dir=Podadresar pro domovske adresare postovnich uzivatelu,0,20
line2=Predvolby pro nove domeny,11
home_format=Domovsky podadresar,10,-Automaticky,Dle vzoru (lze pouzit $USER a $DOM)
line3=Extra moduly dostupne serverovym administratorum,11
avail_cron=Naplanovane ulohy demona Cron,1,1-Ano,0-Ne
ldap_aclasses=Dodatecne objekty LDAP aliasu,0
pre_command=Prikazy ke spusteni pred aplikovanim zmen na serveru,0
passwd_mode=Typ pole hesla,1,1-Nahodne generovane heslo,0-Zadavat heslo jednou,2-Zadavat heslo dvakrat
line4.7=Nastaveni filtrace spamu,11
mysql_replicas=Dodatecne MySQL servery&#44; kterym bude take pridan vytvoreny uzivatel,3,Pouze tento system
leave_acl=Vzdy aktualizovat pristupova prava k modulum Webminu?,1,0-Ano,1-Ne
quota_set_group_command=Prikaz k nastaveni omezeni Quota skupin,3,Pouzivat standardni programy
spam_white=Vychozi nastaveni k povoleni doruceni spamu,1,1-Umoznit,0-Zakazat
show_quotas=Zobrazit vyuziti disku na titulni strane?,1,1-Ano,0-Ne
avail_shell=Prikazovy radek,1,1-Ano,0-Ne
avail_proc=Spustene procesy (pouze uzivatele),1,2-Vlastni procesy,1-Vsechny procesy,0-Ne
template_auto=Umoznit upravu moznosti vzoru behem vytvareni serveru?,1,0-Ano,1-Ne
edit_homes=Muze vybirat domovske adresare uzivatelum?,1,1-Ano,0-Ne
compression=Komprimovaci format zalohy,1,0-<tt>gzip</tt>,1-<tt>bzip2</tt>,2-bez komprimace (pouze <tt>tar</tt>),3-<tt>zip</tt>
groupsame=Zajistit totoznost nazvu skupiny s nazvem uzivatele?,1,1-Ano,0-Ne
avail_telnet=SSH/Telnet prihlaseni,1,1-Ano,0-Ne
other_doms=Informovat ostatni moduly behem upravy postovniho Unix uzivatele?,1,1-Ano,0-Ne
avail_web=Webseerver Apache,1,1-Ano,0-Ne
line4.8=Prikazy omezeni Quota,11
iface=Sitove rozhranni pro virtualni adresy,3,Detekovat automaticky
ldap_port=LDAP port,3,Vychozi
avail_mailboxes=Cist postu uzivatelu,1,1-Ano,0-Ne
disable=Doplnky soucasne deaktivovane behem zakazovani domeny,13,unix-Unixovy uzivatel(uzamknout),mail-Posta (zastavi prijem posty pro domenu),web-Domovska stranka (nahradi chybovou zpravou),dns-DNS zaznam (prestane obsluhovat domenu),mysql-MySQL (zakaze prihlaseni k mySQL),postgre-PostgreSQL (zakaze prihlaseni postgreSQL),ftp/ProFTPD (zakaze pristup)
edit_ftp=Muze vytvaret uzivatele FTP?,1,1-Ano,0-Ne
quota_get_group_command=Prikaz k nastaveni omezeni Quota skupin,3,Pouzivat standardni programy
alias_types=Povolene typy aliasu,13,1-Adresa,2-Adresa v souboru,3-Soubor,4-Program,5-Automaticka odpoved,6-Filtr,7-Postovni schranka jineho uzivatele,8-Stejna schranka v domene,9-Opakovany pokus o doruceni,10-Postovni schranka uzivatele,11-Vymazat,12-Soubor agenta automaticke odpovedi
avail_passwd=Zmenit heslo,1,2-Hesla postovnich uzivatelu,1-Hesla uzivatelu,0-Ne
line4.5=Nastaveni Qmail+LDAP,11
preload_mode=Zavadet knihovny Virtualminu pri startu?,1,2-Vsechny knihovny,1-Pouze knihovny jadra,0-Zadne
show_pass=Lze zobrazit hesla postovnich uzivatelu a domeny?,1,1-Ano,0-Ne
vpopmail_user=Uzivatel VPOPMail,5
show_nf=Zobrazovat nove doplnky,2,master-Hlavnimu administratorovi,domain-Vlastnikum domen
proxy_pass=Povolit vytvareni domovskych stranek pouze za ucelem dopredne relokace na jine stranky?,1,1-Ano&#44; pomoci proxy,2-Ano&#44; pomoci vyrovnavaci pameti ramcu,0-Ne
quota_get_user_command=Prikaz k nastaveni omezeni Quota uzivatelu,3,Pouzivatl standardni programy
other_users=Informovat ostatni moduly behem upravy Unix uzivatele spravce domeny?,1,1-Ano,0-Ne
quota_commands=Pouzivat externi prikazy za ucelem nastaveni a ziskani informaci omezeni Quota?,1,1-Ano,0-Ne
line6=Rozsirene nastaveni,11
display_max=Maximalni pocet zobrazenych domen,3,Neomezene
limitnoalias=Zahrnout alias servery do omezeni?,1,0-Ano,1-Ne
avail_file=Souborovy manager (v ramci domovskeho adresare),1,1-Ano,0-Ne
quota_list_groups_command=Prikaz k vypsani omezeni Quota skupin,3,Pouzivat standardni programy
line5=Moduly Webmin k dispozici pro serverove administratory,11
localgroup=Primarni skupina pro mistni uzivatele,3,Nezobrazovat mistni uzivatele
from_addr=Odesilatel pro emaily odeslane Virtualminem,3,Vychozi
longname=Zpusob uvedeni domeny v nazvu uzivatele,10,1-Plny nazev domeny,0-Uzivatelske jmeno nebo prvni cast domeny,2-Prvni cast domeny,Patró especial d'expressions regulars
ldap_login=Prihlaseni k LDAP serveru,0
local_template=Soubor se vzorem emailu pro nove lokalni uzivatele,10,none-Zadny,default,Vychozi
mail_skel=Vychozi adresar se soubory pro postovni uzivatele,3,Zadny
ca_tmpl=Vzor pro cestu k CA certifikatu,3,Vychozi (<tt>~/ssl.ca</tt>)
ldap_host=LDAP server,0
avail_webalizer=Analyzator log souboru Webalizer,1,1-Ano,0-Ne
ldap_props=Dodatecne atributy LDAP uzivatelu,9,40,3,\t
edit_afiles=Muze editovat pridruzene aliasy a soubor automaticke odpovedi?,1,1-Ano,0-Ne
line4.6=Nastaveni VPOPMail,11
line1.4=NAstaveni uzivatelskeho rozhranni,11
delete_indom=Behem vymazu virtualniho serveru take virtualni server Apache,1,1-Ano,0-Ne
ldap_mail=Pridat atribut mail uzivatelum LDAP?,1,1-Ano&#44; pouze atribut <tt>mail</tt>,2-Ano&#44; pouzitim atributu <tt>mail</tt> a <tt>MailAlternateAddress</tt>,0-Ne
post_check=Uktualizovat vsechny uzivatele Webminu pri zmene konfigurace?,1,1-Ano,0-Ne
ldap_mailstore=Ulozna posty pro uzivatele,0
clam_delivery=Vychozi dorucovani zavirovanych zprav,10,/dev/null-Vymazat,$HOME/mail/virus-Schranka pro viry mbox,$HOME/Maildir/.virus/-Schranka pro viry Maildir,Jiny soubor ci emailova adresa
collect_interval=Interval mezi sberem informaci o stavu,10,none-Nikdy,Minut
avail_dns=DNS Server Bind,1,1-Ano,0-Ne
defip=Vychozi IP adresa virtualniho serveru,3,Ziskat ze sitoveho rozhranni
spam_delivery=Vychozi doruceni spamu,10,-Dorucit normalne,/dev/null-Vymazat,$HOME/mail/spam-Postovni schranka mbox,$/HOME/Maildir/.spam/-Postovni schranka Maildir,Jiny soubor ci emailova adresa
domains_group=Pridat vsechny spravce serveru do skupiny,3,Zadne
line2.1=NAstaveni SSL,11
vpopmail_dir=Zakladni adresar VPOPMail,0
home_base=Umisteni domovskych adresaru,3,Z modulu Uzivatele a Skupiny
append=Zahrnou nazev domeny v nazvu uzivatelskeho uctu?,1,1-Vzdy,0-Pouze ve znaze zamezit konfliktu
avail_spam=Postovni filtr SpamAssasin,1,1-Ano,0-Ne
ldap_unix=Qmail LDAP uzivatele jsou zaroven unixovymi uzivateli?,1,1-Ano,0-Ne
webmin_theme=Tema Webminu pro administratory serveru,15,theme,webmin_theme
user_template=Soubor se vzorem emailu novym uzivatelum,10,none-Zadny,defalut-Vychozi
avail_mysql=Databazovy server MySQL,1,1-Ano,0-Ne
vpopmail_auto=Cesta k programu automatickeho odpovidani,3,Neni instalovan
ldap_classes=Dodatecne objekty LDAP uzivatelu,0
bw_template=Soubor se vzorem emailu domenam s prekrocenym limitem prenosu,10,default-Vychozi
show_ugroup=Povolit vyber jine skupiny pro spravce serveru?,1,1-Ano,0-Ne
quota_set_user_command=Prikaz k nastaveni omezeni Quota uzivatelu,3,Pouzivat standardni programy
domains_sort=Seradit virtualni servery dle,1,user-Vlastnika,dom-Nazvu domeny,owner-Popisu
spam_level=Vychozi hodnoceni spamu k rozhodnuti vymazat,3,Nemazat,4
line1=Nastaveni serveru,11
post_command=Prikazy ke spusteni po aplikovani zmen na serveru,0
webalizer_nocron=Prednastavit Cron ulohu Webalizeru pro kazdy virtualni server?,1,0-Ano,1-Ne
generics=Aktualizovat take odchozi adresy postovnich uzivatelu?,1,1-Ano,0-Ne
update_template=Soubor se vzorem emailu k doruceni upravenym postovnim uzivatelum,10,default-Vychozi
key_tmpl=Vzor pro cestu k privatnimu klici,3,Vychozi (<tt>~/ssl.key</tt>)
denied_domains=Regularni vyraz pro zakazane domeny,0
name_max=Maximalni zobrazena delka domeny,0,5
delete_virts=Behem vymazu emailova adresy vymazat take pridruzene aliasy?,1,1-Ano,0-Ne
avail_postgres=Databazovy server PostgreSQL,1,1-Ano,0-Ne
quota_list_users_command=Prikaz k vypsani omezeni Quota uzivatelu,3,Pouzivat standardni programy
ldap_pass=Heslo k LDAP serveru,0
passwd_length=Delka nahodne generovaneho hesla,3,Vychozi (15 znaku),5
