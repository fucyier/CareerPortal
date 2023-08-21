// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./EgitimBilgileri.sol";
import "./YabanciDilBilgileri.sol";
import "./KursBilgileri.sol";
import "./NitelikBilgileri.sol";
import "./CalismaBilgileri.sol";
import "./SertifikaBilgileri.sol";
import "./BaseProperties.sol";

contract Talep is BaseProperties{

BaseContract baseContract;
EgitimBilgileri egitimKontrati;
CalismaBilgileri calismaKontrati;
YabanciDilBilgileri yabanciDilKontrati;
KursBilgileri kursKontrati;
NitelikBilgileri nitelikKontrati;
SertifikaBilgileri sertifikaKontrati;

    constructor(address _baseKontrati,address _egitimKontrati,address _calismaKontrati, address _yabanciDilKontrati, address _kursKontrati, address _nitelikKontrati,address _sertifikaKontrati)  {
         baseContract=BaseContract(_baseKontrati);
        egitimKontrati=EgitimBilgileri(_egitimKontrati);
        calismaKontrati=CalismaBilgileri(_calismaKontrati);
        yabanciDilKontrati=YabanciDilBilgileri(_yabanciDilKontrati);
        kursKontrati=KursBilgileri(_kursKontrati);
        nitelikKontrati=NitelikBilgileri(_nitelikKontrati);
        sertifikaKontrati=SertifikaBilgileri(_sertifikaKontrati);
    }
  modifier _sadeceKisi{
      require(baseContract.isKisi(msg.sender),
      "Bu islemi sadece Kisi yapabilir."
      );
      _;
      }
   function talepEtEgitimBilgi(address _talepEdilenKurum, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte, 
         uint16 bolum, OgretimTipi ogretimTipi ) public _sadeceKisi{
             egitimKontrati.talepEtEgitimBilgi(msg.sender, _talepEdilenKurum,  egitimDurumu,  basTarih,  bitTarih,   diplomaBelge,   transcriptBelge,  universite,  fakulte,  bolum,  ogretimTipi);
         }
       function talepEtCalismaBilgi(address _talepEdilenKurum, string memory pozisyon, string memory sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir) public  _sadeceKisi{
             calismaKontrati.talepEtCalismaBilgi(msg.sender,_talepEdilenKurum, pozisyon, sektor, calismaTipi, isAciklama, basTarih, bitTarih, ulke, sehir);
       }
        function talepEtYabanciDilBilgi(address _talepEdilenKurum, uint basTarih, uint bitTarih, EgitimBilgileri.OgretimTipi ogretimTipi, uint32 dilId, Seviye seviye) public _sadeceKisi {
            yabanciDilKontrati.talepEtYabanciDilBilgi(msg.sender,_talepEdilenKurum, basTarih, bitTarih, ogretimTipi, dilId, seviye);
        }
        function talepEtKursBilgi(address _talepEdilenKurum,  uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public _sadeceKisi{
            kursKontrati.talepEtKursBilgi(msg.sender,_talepEdilenKurum, basTarih, bitTarih, sure, egitimAdi);
        }
        function talepEtNitelikBilgi(address _talepEdilenKurum, uint nitelikKodu, string memory aciklama, Seviye seviye) public _sadeceKisi{
            nitelikKontrati.talepEtNitelikBilgi(msg.sender,_talepEdilenKurum, nitelikKodu, aciklama, seviye);
        }
        function talepEtSertifikaBilgi(address _talepEdilenKurum, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public _sadeceKisi{
            sertifikaKontrati.talepEtSertifikaBilgi(msg.sender, _talepEdilenKurum,  _alinanTarih,  _gecerlilikSuresi,   _sertifikaAdi);
        }
    
}