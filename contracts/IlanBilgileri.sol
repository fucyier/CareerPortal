// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract IlanBilgileri is BaseContract{

BaseContract baseContract;
        uint public id;
        uint public basvuruId;
        struct IlanBilgi {
         address talepEdenKurum;
         uint32 pozisyon;
         uint8 sektor;
         CalismaTipi calismaTipi;
         string arananOzellikler;
         string isTanimi;
         uint ilanBasTarih;
         uint ilanBitTarih;
         uint8 tecrubeYili;
         uint8 ulke;
         uint32 sehir;
        }
       
        mapping(uint=>IlanBilgi) public ilanBilgileri;
        mapping(uint=>mapping(address=>Kisi)) public ilanBasvuruListesi;

        event IlanBilgiEklendiLog(uint _id, address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor);
        event IlanBilgiGuncellendiLog(uint _id, address _talepEdenKurum, uint32 _pozisyon, uint8 _sektor);
        event IlanBasvuruLog(uint _ilanId,address _basvuranKisi );


constructor(address baseAddress)  {
        baseContract=BaseContract(baseAddress);
      
    }
     modifier _yetkiliPaydas{
      require(baseContract.isKamuKurumu(msg.sender)||baseContract.isFirma(msg.sender),
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
  function ekleIlanBilgi( uint32 _pozisyon, uint8 _sektor, CalismaTipi _calismaTipi, string memory _arananOzellikler, string memory _isTanimi, uint _ilanBasTarih, uint _ilanBitTarih, 
                        uint8 _ulke, uint32 _sehir, uint8 _tecrubeYili)  public _yetkiliPaydas{
            require(baseContract.isKamuKurumu(msg.sender)||baseContract.isFirma(msg.sender),"Ilan acan kurum kayitli degil");
             uint yeniId=id++;
            
             ilanBilgileri[yeniId].talepEdenKurum=msg.sender;
             ilanBilgileri[yeniId].pozisyon=_pozisyon;
             ilanBilgileri[yeniId].sektor=_sektor;
             ilanBilgileri[yeniId].calismaTipi=_calismaTipi;
             ilanBilgileri[yeniId].arananOzellikler=_arananOzellikler;
             ilanBilgileri[yeniId].isTanimi=_isTanimi;
             ilanBilgileri[yeniId].ilanBasTarih=_ilanBasTarih;
             ilanBilgileri[yeniId].ilanBitTarih=_ilanBitTarih;
             ilanBilgileri[yeniId].tecrubeYili=_tecrubeYili;
             ilanBilgileri[yeniId].ulke=_ulke;
             ilanBilgileri[yeniId].sehir=_sehir;

           
             emit IlanBilgiEklendiLog( yeniId,msg.sender, _pozisyon,_sektor );
    }
       function guncelleIlanBilgi(uint _ilanId, uint32 _pozisyon, uint8 _sektor, CalismaTipi _calismaTipi, string memory _arananOzellikler, string memory _isTanimi, uint _ilanBasTarih, uint _ilanBitTarih, 
                        uint8 _ulke,uint32 _sehir, uint8 _tecrubeYili)  public _yetkiliPaydas returns(uint){
           require(baseContract.isKamuKurumu(msg.sender)||baseContract.isFirma(msg.sender),"Ilan acan kurum kayitli degil");
             require(ilanBilgileri[_ilanId].talepEdenKurum==msg.sender,"Ilan acan guncelleme islemi yapabilir");
             ilanBilgileri[_ilanId].pozisyon=_pozisyon;
             ilanBilgileri[_ilanId].sektor=_sektor;
             ilanBilgileri[_ilanId].calismaTipi=_calismaTipi;
             ilanBilgileri[_ilanId].arananOzellikler=_arananOzellikler;
             ilanBilgileri[_ilanId].isTanimi=_isTanimi;
             ilanBilgileri[_ilanId].ilanBasTarih=_ilanBasTarih;
             ilanBilgileri[_ilanId].ilanBitTarih=_ilanBitTarih;
             ilanBilgileri[_ilanId].tecrubeYili=_tecrubeYili;
             ilanBilgileri[_ilanId].ulke=_ulke;
             ilanBilgileri[_ilanId].sehir=_sehir;
           
             emit IlanBilgiGuncellendiLog( _ilanId,msg.sender, _pozisyon,_sektor );
             return _ilanId;

    }

 function basvurIlan(uint _ilanId)  public _sadeceKisi returns(uint){
            require(ilanBasvuruListesi[_ilanId][msg.sender].durum,"Ayni ilana daha once basvurulmus");
             //  uint _basvuruId=basvuruId++;
             ilanBasvuruListesi[_ilanId][msg.sender].durum=true;
            
           
             emit IlanBasvuruLog( _ilanId,msg.sender );
             return _ilanId;

    }

    
}