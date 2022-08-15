// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract NitelikBilgileri is BaseContract{
  uint public id;

    struct NitelikBilgi {
         uint id;
         OnaylayanKurum onayKurumTipi;
         address onayKurumAdres;
         uint onayTarih;
         uint nitelikKodu;
         string aciklama;
         Seviye seviye;
         Onay onayBilgi;
        }
        mapping(address=>mapping(uint=>NitelikBilgi)) public nitelikBilgiListesi;



        event NitelikEklendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);
        event NitelikGuncellendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);

         function ekleNitelikBilgi(address _kisiAddress,  OnaylayanKurum onayKurumTipi, address onayKurumAdres, uint onayTarih, uint nitelikKodu, string memory aciklama, Seviye seviye)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayKurumTipi=onayKurumTipi;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayKurumAdres=onayKurumAdres;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayTarih=onayTarih;
             nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][yeniId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
               nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
                 nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
           
            emit NitelikEklendiLog(onayKurumAdres, onayTarih, nitelikKodu);
        }
          function guncelleNitelikBilgi(address _kisiAddress,uint nitelikBilgiId, OnaylayanKurum onayKurumTipi, address onayKurumAdres, uint onayTarih, uint nitelikKodu, string memory aciklama, Seviye seviye)  public sadece_Uni_Firma_Kamu returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayKurumTipi=onayKurumTipi;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayKurumAdres=onayKurumAdres;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayTarih=onayTarih;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
            nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.adres=msg.sender;
                 nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman=block.timestamp;
             emit NitelikGuncellendiLog(onayKurumAdres, onayTarih, nitelikKodu);
                return    nitelikBilgiId;

        }



}