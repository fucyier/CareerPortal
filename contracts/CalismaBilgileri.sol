// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
contract CalismaBilgileri is BaseContract{
  uint public id;

    struct CalismaBilgi {
         uint id;
         address kurumAdres;
         uint32 pozisyon;
         uint8 sektor;
         CalismaTipi calismaTipi;
         string isAciklama;
         uint basTarih;
         uint bitTarih;
         uint8 ulke;
         uint32 sehir;
        }
       
         enum CalismaTipi { 
             YariZamanli, 
             TamZamanli, 
             Stajyer}

        mapping(address=>mapping(uint=>CalismaBilgi)) public calismaBilgileri;
      
      
        event CalismaBilgiEklendiLog(uint id, address _universite, uint basTarih, uint bitTarih);
          event EgitimBilgiGuncellendiLog(uint id, address _universite, uint basTarih, uint bitTarih);

         function ekleEgitimBilgi(address _kisiAddress, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, uint8 diplomaNotu, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte, uint16 bolum, OgretimTipi ogretimTipi, uint32 ogretimDili)  internal sadeceUniversite{
             require(kisiler[_kisiAddress].durum,"Student not exists");
             uint yeniId=id++;
             egitimBilgileri[_kisiAddress][yeniId].egitimDurumu=egitimDurumu;
             egitimBilgileri[_kisiAddress][yeniId].basTarih=basTarih;
             egitimBilgileri[_kisiAddress][yeniId].bitTarih=bitTarih;
             egitimBilgileri[_kisiAddress][yeniId].diplomaNotu=diplomaNotu;
             egitimBilgileri[_kisiAddress][yeniId].diplomaBelge=diplomaBelge;
             egitimBilgileri[_kisiAddress][yeniId].transcriptBelge=transcriptBelge;
             egitimBilgileri[_kisiAddress][yeniId].universite=universite;
             egitimBilgileri[_kisiAddress][yeniId].fakulte=fakulte;
             egitimBilgileri[_kisiAddress][yeniId].bolum=bolum;
             egitimBilgileri[_kisiAddress][yeniId].ogretimTipi=ogretimTipi;
             egitimBilgileri[_kisiAddress][yeniId].ogretimDili=ogretimDili;
           //  egitimBilgileri[_personAddress][yeniId].ulke=_egitimBilgi.ulke;
            // egitimBilgileri[_personAddress][yeniId].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiEklendiLog( yeniId, universite,basTarih, bitTarih);
    }
       function guncelleEgitimBilgi(address _kisiAddress, uint _egitimBilgiId, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, uint8 diplomaNotu, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte, uint16 bolum, OgretimTipi ogretimTipi, uint32 ogretimDili)  internal sadeceUniversite returns(uint){
             require(kisiler[_kisiAddress].durum,"Student not exists");
             
             egitimBilgileri[_kisiAddress][_egitimBilgiId].egitimDurumu=egitimDurumu;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].basTarih=basTarih;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].bitTarih=bitTarih;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].diplomaNotu=diplomaNotu;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].diplomaBelge=diplomaBelge;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].transcriptBelge=transcriptBelge;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].universite=universite;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].fakulte=fakulte;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].bolum=bolum;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].ogretimTipi=ogretimTipi;
             egitimBilgileri[_kisiAddress][_egitimBilgiId].ogretimDili=ogretimDili;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].ulke=_egitimBilgi.ulke;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiGuncellendiLog( _egitimBilgiId, universite, basTarih, bitTarih);
             return _egitimBilgiId;

    }
     
}