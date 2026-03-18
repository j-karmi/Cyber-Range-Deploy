# Automatizace nasazení Windows VM a Linux VM z Linux  

Pro řešení jsem vybral virtualizaci pomocí QEMU/KVM, přestože jsem s tím virtualizačním nástrojem doposud neměl vůbec žádné zkušenosti. To s sebou přineslo mnoho problémů. Výsledný skript není plně funkční a má také mnoho míst k vylepšení (označeno TODO).  
Vývojovým prostředím pro hypervizor byl Kali 2026.1  



---

Pro úspěšné spuštění scriptu pro nasazení VM strojů je potřeba doinstalování několika balíčků. Jedná se o:
- qemu-kvm                  --> samotný hypervizor
- libvirt-daemon-system     --> knihovna pro práci s VMs
- virtinst                  
- cloud-image-utils         
- yq                        --> použití pro parsování dat z yaml souborů v bash scriptech, není teda potřeba parsování yaml souborů mnou vytvářenými python scripty

Kontrolu správného nainstalování těch relevantních pro konkrétní VM je řešen dvěma různými způsoby. U Windows ho provádí odpovídající script dependencies.sh. U linuxu jsem zvolil cestu uživatelské funkce s jedním parametrem - názvem balíčku - která postuopně testuje přítomnost všech potřebných přímo v těle scriptu pro nasazení VM.

---
Po spuštění hlavního scriptu je uživatel dotázán, který VM chce nasadit:
- [1] --> Instalace Windows server 2019
- [2] --> Instalace Ubuntu desktop
- [3] --> Instalace obou strojů
- [4] --> Konec

---
### config.yaml
Konfigurční soubor `config.yaml` obsahuje základní sadu uživatelem definovaných dat, která jsou potřbea pro bezobslužnou instalaci VM. Rozhodl jsem se nepoužívat jeden .yaml soubor v kořenovém adresáři, který by byl sdílený pro oba VM (Windows i Linux), ale rozdělit jej na dvě části a umístit je ke zbytku scriptů do odpovídající složky dle OS. Tento přístup mně přijde logičtější z hlediska spravování. Tímto řešením příliš nenabobtná v případě použití většího množství VM a také jsou jednotlivé složky pro různé OS lépe přenositelné.

--- 
## Instalace Windows serveru 2019

Po vybrání první možnosti se postupně spouští ostatní pomocné scripty. 
- prvně se kontroluje přítomnost požadovaných balíčků pomocí dependencies.sh
- dále se stahují dva potřebné ISO soubory. Tento krok je přeskočen, pokud už jsou požadované soubory přítomny ve složce "ISO":
    - virtio-win.iso
        - ovladače pro VM. Použije se ovladač pro iSCSI disk
    - windows_server_2019_eval.iso
        - obraz instalace MS Windows 2019
        - použité URL: https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US
        - originální název ISO souboru: 17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us
    - názvy souborů musí přesně odpovídat
- do složky "build" je vygenerován soubor autounattend.xml pomocí skriptu z šablony uložené ve složce "templates". Z tohoto vygenerovaného souboru je poté vytvořen .iso soubor, který instalátoru systému poskytne tzv. answer soubor.  
- v šabloně pro xml je také uložen post install příkaz na spuštění scriptu setup_iis.ps1, který je též uložený v tomto .iso souboru. Tento powershell script zapne službu IIS a do správné složky zkopíruje referenční index.html, který byl také zabalen do autounattended.iso a je po nainstalování systému vidět jako CD-ROM s daty.  
- použití šablony je v příípadě instalace Windows vhodné kvůli její délce a složitosti.
- samotné nasazení probíhá pomocí nástroje virt-install. Hodnoty potřebných argumentů, jako je požadovaný název VM, velikost disku, počet jader CPU apod. je načten ze souboru config.yaml pomocí utility yq.

---
## Instalace Ubuntu Desktop

Scripty pro instalaci Ubuntu Linuxu nejsou funkční. Nepodařilo se mi napsat script tak, aby správně importoval data z config.yaml a aplikoval je do bezobslužné instalace.  
Testoval jsem jak img výrazně vhodnější předinstalované verze cloudimage pro VM s web serverem tak iso plného desktopu (proto název složek).  
Při vývoji se mi podařilo napsat script tak, aby se instalace spustila v klasickém "klikacím" gui, kde stačilo stiskem tlačítka spustit instalaci, kdy se úspěšně aplikovaly požadované nastavení a uživatelské účty z config.yaml.
Při následném "ladění", aby instalace probíhala bez grafického rozhraní a zcela bezobslužně se mi ovšem podařilo vše rozbít a teď se pouze nainstaluje a spustí holý linux z img bez modifikací.  

V případě instalace Ubuntu je požadovaný konfigurační soubor `user-data` vygenerován kompletně jako text ze skriptu `generate_metadata.sh`. I zde by, stejně jako v případě instalace Windows, bylo vhodnější použití šablony, která by se modifikovala na požadované hodnoty. Pak by byly scripty přehlednější a user-data snadnější na management. V rámci dema je ale vygenerování v zásadě statického textového souboru akceptovatelné.

Naimportování jednoduchého `index.html` je zde řešeno jako přímý zápis zakódovaného obsahu v base64 `INDEX_CONTENT=$(base64 -w0 "$INDEX")` do souboru pomocí bloku `write_files:` v autoinstall v user-data. Toto řešení opravdu není vhodné pro větší množství souborů nebo dat, ale je to něco jiného oproti přístupu u nasazení VM Windows. 

---
## Závěrečné hodnocení
Zpětně hodnotím jako špatné rozhodnutí zkusit vytvářet virtuální stroje v pro mě novém, neznámém prostředí qemu/kvm. Výsledek by byl jistě uspokojivější, kdybych od začátku používal například VirtualBox, se kterým mám více zkušeností.  
Z dvou požadovaných VM se mi podařilo scriptem nasadit a nastavit dle zadání obě dvě ale ne zcela bezobslužně. Jsem z konečného výsledku poměrně zklamaný, protože nutnost odklikávat cokoliv během deploymentu docela kazí celý smysl nasazování VM pomocí scriptů.