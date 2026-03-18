<img height="50" src="https://qemu.weilnetz.de/icon/benoit/black_and_orange_qemu_head-128x128.png">
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/linux.png">
<img height="50" src="https://www.zubairalexander.com/blog/wp-content/uploads/2022/04/ws2019-675-335-860x520.png">

---
# Automatické vytvoření a nainstalovaní WINDOWS 2019 a UBUNTU DESKTOP virtual machines na Linux
Sada skriptů automaticky nasadí dva virtuální stroje - konkrétně Windows server 2019 a Ubuntu Desktop - pomocí qemu/kvm na Linuxovém hostu. V případě nutnosti
automaticky stáhne požadované instalační .iso soubory a vytvoří VM pomocí `virt-install`.  
Po spuštění iniciačního scriptu `go.sh` je uživateli dána možnost výběru, které instalace se mají provést. Další akce se řídí scripty v odpovídajících složkách "w19" nebo "ubuntu-desktop". Tam se také nacházejí konfigurační soubory `config.yaml` s informacemi důležitými pro bezobslužnou instalaci daného operačního systému.

## Quick start
`go.sh` <-- spuštění menu pro výběr instalace
``` bash
[1] --> Instalace Windows server 2019
[2] --> Instalace Ubuntu desktop
[3] --> Instalace obou strojů
[4] --> Konec
```

## Cleanup
Script `destroy.sh` smaže oba vytvořené vitruální stroje a vrátí systém do původního stavu.

## TODOs
- vyřešení problému s `Press any key to boot form CD or DVD...` u Windows
- vyřešení správného importu virtio driverů pro disk bez nutnosti manuálního hledání u Windows (*"Load driver" --> "Browse" --> F:\viostor\2k19\amd64 --> OK*)
- funkční načtení seed.iso pro nastavení po instalaci u Ubuntu
- dynamické generpvání bloku s uživateli v autounattend.xml. Nyní se doplní pouze jeden uživatel a administrator na předpřipravené placeholdery.
---
# Instalace VM Windows Server 2019
<img height="50" src="https://www.zubairalexander.com/blog/wp-content/uploads/2022/04/ws2019-675-335-860x520.png">

konfigurační soubor :
 - w19/config.yaml

instalační script:
 - w19/deploy.sh

---
Prvním krokem je kontrola přítomnosti požadovaných balíčků a případně jejich okamžitá instalace pomocí scriptu `dependencies.sh`  
Druhý skript po spuštění stáhne do složky "ISO" dva soubory:
- *virtio-win.iso*
    - ovladače pro VM. Použije se ovladač pro iSCSI disk
- *windows_server_2019_eval.iso*
    - obraz instalace MS Windows 2019
    - použité URL: https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US
    - originální název ISO souboru: 17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us
- názvy souborů musí přesně odpovídat

Třetí script poté vytvoří VM pomocí `virt-install`.
Po spuštění VM se k němu automaticky připojí konzolí, protože je třeba manuálně odkliknout "`Press any key to boot from CD or DVD...`" <-- TO DO

Dalším zádrhelem je potřeba manuálního načtení ovladačů pro disk. Instalátor chce interkativně vybrat možnost "Load driver" --> "Browse" --> F:\viostor\2k19\amd64 --> OK a zvloit disk pro nainstalování. Instalace pak už pokračuje opět automaticky <-- TO DO

Zbytek instalace probíhá bezobslužně z dat v konfiguračním config.yaml souboru

---
# Instalace VM Ubuntu Desktop
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/linux.png">

konfigurační soubor :
 - ubuntu-desktop/config.yaml

instalační script:
 - ubuntu-desktop/deploy.sh

---
Sekvence instalace probíhá v pořadí:
- stažení iso souboru `ubuntu-24.04.4-desktop-amd64.iso`
- vygenerování `user-data` dle atributů v ubuntu-desktop/config.yaml a statického `meta-data` a následné vytvoření `seed.iso`
- vytvoření VM pomocí `virt-install`
- grafický instalátor reportuje 2 chyby, špatně napsaný user-data?? <-- TODO
- !! NEAPLIKOVÁNÍ seed.iso !! --> po instalaci je použitelný pouze defaultní uživatel `ubuntu` a není spuštěný web server ani naimporotvaný index.html <-- TODO