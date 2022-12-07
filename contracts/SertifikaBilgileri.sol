// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";

contract SertifikaBilgileri is BaseContract{
  uint public id;
  BaseContract baseContract;
    struct SertifikaBilgi {
         uint id;
         address talepEdilenKurum;
         uint alinanTarih;
         uint8 gecerlilikSuresi;
         string sertifikaAdi;
         Onay onayBilgi;
        }
        mapping(address=>mapping(uint=>SertifikaBilgi)) public sertifikaBilgiListesi;



        event SertifikaEklendiLog(uint _id, uint _alinanTarih, uint _gecerlilikSuresi);
        event SertifikaGuncellendiLog(uint _sertifikaBilgiId, uint _alinanTarih, uint _gecerlilikSuresi);
        event SertifikaTalepEdildiLog(uint _sertifikaBilgiId, uint _alinanTarih, uint _gecerlilikSuresi);
 constructor(address baseAddress)  {
        baseContract=BaseContract(baseAddress);
      
    }
     modifier _yetkiliPaydas{
      require(baseContract.isSertifikaMerkezi(msg.sender),
      "Sadece yetkili paydas bu islemi yapabilir."
      );
      _;
    } 
      modifier _sadeceKisi{
      require(baseContract.isKisi(msg.sender),
      "Bu islemi sadece Kisi yapabilir."
      );
      _;
    } 
         function ekleSertifikaBilgi(address _kisiAddress, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public _yetkiliPaydas{
            require(baseContract.isKisi(_kisiAddress),"Kisi bulunamadi");
            
             uint yeniId=id++;
             sertifikaBilgiListesi[_kisiAddress][yeniId].alinanTarih=_alinanTarih;
             sertifikaBilgiListesi[_kisiAddress][yeniId].gecerlilikSuresi=_gecerlilikSuresi;
             sertifikaBilgiListesi[_kisiAddress][yeniId].sertifikaAdi=_sertifikaAdi;
             sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
             sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;

             emit SertifikaEklendiLog(yeniId, _alinanTarih, _gecerlilikSuresi);
        }
          function guncelleSertifikaBilgi(address _kisiAddress, uint _sertifikaBilgiId, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public _yetkiliPaydas returns(uint){
            
            require(baseContract.isKisi(_kisiAddress),"Kisi bulunamadi");
                
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].alinanTarih=_alinanTarih;
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].gecerlilikSuresi=_gecerlilikSuresi;
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].sertifikaAdi=_sertifikaAdi;
       
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.zaman=block.timestamp;
             sertifikaBilgiListesi[_kisiAddress][_sertifikaBilgiId].onayBilgi.adres=msg.sender;

              emit SertifikaGuncellendiLog(_sertifikaBilgiId,  _alinanTarih,  _gecerlilikSuresi);
                return _sertifikaBilgiId;

        }
        
         function talepEtSertifikaBilgi(address _kisiAddress,address _talepEdilenKurum, uint _alinanTarih, uint8 _gecerlilikSuresi, string memory _sertifikaAdi) public {
             require(baseContract.isKisi( _kisiAddress),"Kisi mevcut degil");
            
             uint yeniId=id++;
             sertifikaBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum=_talepEdilenKurum;
             sertifikaBilgiListesi[_kisiAddress][yeniId].alinanTarih=_alinanTarih;
             sertifikaBilgiListesi[_kisiAddress][yeniId].gecerlilikSuresi=_gecerlilikSuresi;
             sertifikaBilgiListesi[_kisiAddress][yeniId].sertifikaAdi=_sertifikaAdi;
             sertifikaBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;

             emit SertifikaTalepEdildiLog(yeniId, _alinanTarih, _gecerlilikSuresi);
        }



}