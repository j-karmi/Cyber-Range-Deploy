# Instalace VM Windows Server 2019

konfigurační soubor :
 - config.yaml

instalační script:
 - deploy.sh

---

Skript po spuštění stáhne do složky "ISO" dva soubory:
- *virtio-win.iso*
    - ovladače pro VM. Použije se ovladač pro iSCSI disk
- *windows_server_2019_eval.iso*
    - obraz instalace MS Windows 2019
    - použité URL: https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US
    - originální název ISO souboru: 17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us
- názvy souborů musí přesně odpovídat

Poté vytvoří VM pomocí `virt-install`.
Po spuštění VM se k němu automaticky připojí konzolí, protože je třeba manuálně odkliknout "`Press any key to boot from CD or DVD...`" <-- TO DO

Dalším zádrhelem je potřeba manuálního načtení ovladačů pro disk. Instalátor chce interkativně vybrat možnost "Load driver" --> "Browse" --> F:\viostor\2k19\amd64 --> OK a zvloit disk pro nainstalování. Instalace pak už pokračuje opět automaticky <-- TO DO

Zbytek instalace probíhá bezobslužně z dat v konfiguračním config.yaml souboru

# Instalace VM Ubuntu desktop



