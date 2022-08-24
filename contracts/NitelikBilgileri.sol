// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract NitelikBilgileri is BaseContract{
  uint public id;

    struct NitelikBilgi {
         uint id;
         address talepEdilenKurum;
         uint onayTarih;
         uint nitelikKodu;
         string aciklama;
         Seviye seviye;
         Onay onayBilgi;
        }
        mapping(address=>mapping(uint=>NitelikBilgi)) public nitelikBilgiListesi;



        event NitelikEklendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);
        event NitelikGuncellendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);

         function ekleNitelikBilgi(address _kisiAddress, uint nitelikKodu, string memory aciklama, Seviye seviye)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;

             nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][yeniId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
           
            emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
        }
          function guncelleNitelikBilgi(address _kisiAddress,uint nitelikBilgiId, uint nitelikKodu, string memory aciklama, Seviye seviye)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");

             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.adres=msg.sender;     
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman=block.timestamp;
            
             emit NitelikGuncellendiLog(msg.sender, block.timestamp, nitelikKodu);
             return    nitelikBilgiId;

        }



}