Automatizace nasazení Windows VM a Linux VM z Linux

Pro řešení jsem vybral virtualizaci pomocí QEMU/KVM, přestože jsem s tím virtualizačním nástrojem doposud neměl vůbec žádné zkušenosti. To s sebou přineslo mnoho problémů. Výsledný skript není plně funkční a má mnoho míst k vylepšení (označeno TODO).
===
Pro úspěšné spuštění scriptu pro nasazení VM strojů je potřeba doinstalování několika balíčků. Jedná se o:
- qemu-kvm                  --> samotný hypervizor
- libvirt-daemon-system     --> knihovna pro práci s VMs
- virtinst                  -->
- cloud-image-utils         -->
- yq                        --> použití pro parsování dat z yaml souborů v bash scriptech

Kontrolu správního nainstalování těch relevantních pro konkrétní VM provádí odpovídající script dependencies.sh 

===
Po spuštění hlavního scriptu je uživatel dotázán, který VM chce nasadit:
- [1] --> Instalace Windows server 2019
- [2] --> Instalace Ubuntu desktop
- [3] --> Instalace obou strojů
- [4] --> Konec

=== 
Instalace Windows serveru 2019

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
- do složky "build" je vygenerován soubor autounattend.xml pomocí skriptu z šablony uložené ve složce "templates". Z tohoto vygenerovaného souboru je poté vytvořen .iso soubor, který instalátoru systému poskytne tzv. answer soubor. V šabloně pro xml je také uložen post install příkaz na spuštění scriptu setup_iis.ps1, který je též uložený v tomto .iso souboru. Tento powershell script zapne službu IIS a co správné složky zkopíruje referenční index.html, který byl také zabalen do autounattended.iso a je po nainstalování systému vidět jako CD-ROM s daty.
- samotné nasazení probíhá pomocí nástroje virt-install. Hodnoty potřebných argumentů, jako je požadovaný název VM, velikost disku, počet jader CPU apod. je načten ze souboru config.yaml pomocí utility yq.

=== 
Instalace Ubuntu Desktop

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
- do složky "build" je vygenerován soubor autounattend.xml pomocí skriptu z šablony uložené ve složce "templates". Z tohoto vygenerovaného souboru je poté vytvořen .iso soubor, který je instalátorem systému použitý jako tzv. answer soubor.
- samotné nasazení probíhá pomocí nástroje virt-install. Hodnoty potřebných argumentů, jako je požadovaný název VM, velikost disku, počet jader CPU apod. je načten ze souboru config.yaml pomocí utility yq.