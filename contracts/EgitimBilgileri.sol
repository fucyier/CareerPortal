// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
contract EgitimBilgileri is BaseContract{
  uint public id;


    struct EgitimBilgi {
          uint id;
         EgitimDurumu egitimDurumu;
         uint basTarih;
         uint bitTarih;
         uint8 diplomaNotu;
         bytes32 diplomaBelge;
         bytes32 transcriptBelge;
         address universite;
         uint16 fakulte;
         uint16 bolum;
         OgretimTipi ogretimTipi;
         uint32 ogretimDili;
         //uint8 ulke;
         //uint32 sehir;
        }
       
         enum EgitimDurumu { 
             Lisans, 
             OnLisans, 
             YuksekLisans,
             Doktora }

         enum OgretimTipi { 
             OrgunOgretim, 
             AcikOgretim, 
             IkinciOgretim,
             UzaktanOgretim }

               mapping(address=>mapping(uint=>EgitimBilgi)) public egitimBilgileri;
      
      
        event EgitimBilgiEklendiLog(uint id,address _universite,uint basTarih, uint bitTarih);

         function addEgitimBilgi(address _personAddress, EgitimBilgi memory _egitimBilgi)  public sadeceUniversite{
             require(kisiler[_personAddress].durum,"Student not exists");
             uint yeniId=id++;
             egitimBilgileri[_personAddress][yeniId].egitimDurumu=_egitimBilgi.egitimDurumu;
             egitimBilgileri[_personAddress][yeniId].basTarih=_egitimBilgi.basTarih;
             egitimBilgileri[_personAddress][yeniId].bitTarih=_egitimBilgi.bitTarih;
             egitimBilgileri[_personAddress][yeniId].diplomaNotu=_egitimBilgi.diplomaNotu;
             egitimBilgileri[_personAddress][yeniId].diplomaBelge=_egitimBilgi.diplomaBelge;
             egitimBilgileri[_personAddress][yeniId].transcriptBelge=_egitimBilgi.transcriptBelge;
             egitimBilgileri[_personAddress][yeniId].universite=_egitimBilgi.universite;
             egitimBilgileri[_personAddress][yeniId].fakulte=_egitimBilgi.fakulte;
             egitimBilgileri[_personAddress][yeniId].bolum=_egitimBilgi.bolum;
             egitimBilgileri[_personAddress][yeniId].ogretimTipi=_egitimBilgi.ogretimTipi;
             egitimBilgileri[_personAddress][yeniId].ogretimDili=_egitimBilgi.ogretimDili;
           //  egitimBilgileri[_personAddress][yeniId].ulke=_egitimBilgi.ulke;
            // egitimBilgileri[_personAddress][yeniId].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiEklendiLog( yeniId, _egitimBilgi.universite,_egitimBilgi.basTarih, _egitimBilgi.bitTarih);
    }
       function updateEgitimBilgi(address _personAddress, EgitimBilgi memory _egitimBilgi)  public sadeceUniversite returns(uint){
             require(kisiler[_personAddress].durum,"Student not exists");
             
             egitimBilgileri[_personAddress][_egitimBilgi.id].egitimDurumu=_egitimBilgi.egitimDurumu;
             egitimBilgileri[_personAddress][_egitimBilgi.id].basTarih=_egitimBilgi.basTarih;
             egitimBilgileri[_personAddress][_egitimBilgi.id].bitTarih=_egitimBilgi.bitTarih;
             egitimBilgileri[_personAddress][_egitimBilgi.id].diplomaNotu=_egitimBilgi.diplomaNotu;
             egitimBilgileri[_personAddress][_egitimBilgi.id].diplomaBelge=_egitimBilgi.diplomaBelge;
             egitimBilgileri[_personAddress][_egitimBilgi.id].transcriptBelge=_egitimBilgi.transcriptBelge;
             egitimBilgileri[_personAddress][_egitimBilgi.id].universite=_egitimBilgi.universite;
             egitimBilgileri[_personAddress][_egitimBilgi.id].fakulte=_egitimBilgi.fakulte;
             egitimBilgileri[_personAddress][_egitimBilgi.id].bolum=_egitimBilgi.bolum;
             egitimBilgileri[_personAddress][_egitimBilgi.id].ogretimTipi=_egitimBilgi.ogretimTipi;
             egitimBilgileri[_personAddress][_egitimBilgi.id].ogretimDili=_egitimBilgi.ogretimDili;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].ulke=_egitimBilgi.ulke;
           //  egitimBilgileri[_personAddress][_egitimBilgi.id].sehir=_egitimBilgi.sehir;
           
             emit EgitimBilgiEklendiLog( _egitimBilgi.id, _egitimBilgi.universite,_egitimBilgi.basTarih, _egitimBilgi.bitTarih);
             return    _egitimBilgi.id;

    }
     
}