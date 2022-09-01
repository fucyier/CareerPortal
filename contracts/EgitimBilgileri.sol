// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
contract EgitimBilgileri is BaseContract{
    uint public id;

    struct EgitimBilgi {
          uint id;
                address talepEdilenKurum;
         EgitimDurumu egitimDurumu;
         uint basTarih;
         uint bitTarih;
         //uint8 diplomaNotu;
         string diplomaBelge;
         string transcriptBelge;
         address universite;
         uint16 fakulte;
         uint16 bolum;
         OgretimTipi ogretimTipi;
     //    uint32 ogretimDili;
         Onay onayBilgi;
         //uint8 ulke;
         //uint32 sehir;
        }
       
      

        mapping(address=>mapping(uint=>EgitimBilgi)) public egitimBilgileri;
      
      
        event EgitimBilgiEklendiLog(uint id,address _universite,uint basTarih, uint bitTarih);
          event EgitimBilgiGuncellendiLog(uint id,address _universite,uint basTarih, uint bitTarih);
            event EgitimBilgiTalepEdildiLog(uint id,address _universite,uint basTarih, uint bitTarih);

         function ekleEgitimBilgi(address _kisiAddress, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte, 
         uint16 bolum, OgretimTipi ogretimTipi)  internal sadeceUniversite{
             require(kisiler[_kisiAddress].durum,"Student not exists");
             uint yeniId=id++;
             egitimBilgileri[_kisiAddress][yeniId].egitimDurumu=egitimDurumu;
             egitimBilgileri[_kisiAddress][yeniId].basTarih=basTarih;
             egitimBilgileri[_kisiAddress][yeniId].bitTarih=bitTarih;
            // egitimBilgileri[_kisiAddress][yeniId].diplomaNotu=diplomaNotu;
             egitimBilgileri[_kisiAddress][yeniId].diplomaBelge=diplomaBelge;
             egitimBilgileri[_kisiAddress][yeniId].transcriptBelge=transcriptBelge;
             egitimBilgileri[_kisiAddress][yeniId].universite=universite;
             egitimBilgileri[_kisiAddress][yeniId].fakulte=fakulte;
             egitimBilgileri[_kisiAddress][yeniId].bolum=bolum;
             egitimBilgileri[_kisiAddress][yeniId].ogretimTipi=ogretimTipi;
            // egitimBilgileri[_kisiAddress][yeniId].ogretimDili=ogretimDili;
             egitimBilgileri[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
             egitimBilgileri[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
               egitimBilgileri[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
            // egitimBilgileri[_personAddress][yeniId].ulke=_egitimBilgi.ulke;
            // egitimBilgileri[_personAddress][yeniId].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiEklendiLog( yeniId, universite,basTarih, bitTarih);
    }
       function guncelleEgitimBilgi(address _kisiAddress, uint _egitimBilgiId, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, 
       address universite, uint16 fakulte, uint16 bolum, OgretimTipi ogretimTipi)  internal sadeceUniversite returns(uint){
             require(kisiler[_kisiAddress].durum,"Student not exists");
             
             egitimBilgileri[_kisiAddress][_egitimBilgiId].egitimDurumu=egitimDurumu;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].basTarih=basTarih;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].bitTarih=bitTarih;
            // egitimBilgileri[_kisiAddress][_egitimBilgiId].diplomaNotu=diplomaNotu;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].diplomaBelge=diplomaBelge;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].transcriptBelge=transcriptBelge;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].universite=universite;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].fakulte=fakulte;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].bolum=bolum;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].ogretimTipi=ogretimTipi;
           //  egitimBilgileri[_kisiAddress][_egitimBilgiId].ogretimDili=ogretimDili;
              egitimBilgileri[_kisiAddress][_egitimBilgiId].onayBilgi.zaman=block.timestamp;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].onayBilgi.adres=msg.sender;
              egitimBilgileri[_kisiAddress][_egitimBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].ulke=_egitimBilgi.ulke;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiGuncellendiLog( _egitimBilgiId, universite, basTarih, bitTarih);
             return _egitimBilgiId;

    }

      function talepEtEgitimBilgi(address _talepEdilenKurum, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte, 
         uint16 bolum, OgretimTipi ogretimTipi )  external   sadeceKisi{
             require(kisiler[msg.sender].durum,"Student not exists");
             uint yeniId=id++;

               egitimBilgileri[msg.sender][yeniId].talepEdilenKurum=_talepEdilenKurum;
             egitimBilgileri[msg.sender][yeniId].egitimDurumu=egitimDurumu;
             egitimBilgileri[msg.sender][yeniId].basTarih=basTarih;
             egitimBilgileri[msg.sender][yeniId].bitTarih=bitTarih;
             egitimBilgileri[msg.sender][yeniId].diplomaBelge=diplomaBelge;
             egitimBilgileri[msg.sender][yeniId].transcriptBelge=transcriptBelge;
             egitimBilgileri[msg.sender][yeniId].universite=universite;
             egitimBilgileri[msg.sender][yeniId].fakulte=fakulte;
             egitimBilgileri[msg.sender][yeniId].bolum=bolum;
             egitimBilgileri[msg.sender][yeniId].ogretimTipi=ogretimTipi;
          //   egitimBilgileri[msg.sender][yeniId].ogretimDili=ogretimDili;
             egitimBilgileri[msg.sender][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;

           
             emit EgitimBilgiEklendiLog( yeniId, universite,basTarih, bitTarih);
    }
     
}