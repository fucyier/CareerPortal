// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";


contract ReferansBilgileri is BaseContract{
  uint public id;

    struct ReferansBilgi {
         uint id;
         address referansAdres;
         uint onayRedTarih;
         string aciklama;
          string pozisyon;
         ReferansDurum durum;
        
        }

    enum ReferansDurum {
        OnayBekliyor,
        Onaylandi,
        Reddedildi
        } 
        mapping(address=>mapping(uint=>ReferansBilgi)) public referansBilgiListesi;



        event ReferansTalepEtLog(uint id, address _kisiAdres, address _referansAdres,ReferansDurum _durum);
        event ReferansOnayRedLog(uint referansId,address _kisiAddress,address _referansAdres,bool onayRed,uint zaman);

         function talepEtReferans(address _kisiAddress, ReferansBilgi memory _referansBilgi)  public {
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             require(kisiler[_referansBilgi.referansAdres].durum,"Referans Kisi mevcut degil");
             uint yeniId=id++;
             referansBilgiListesi[_kisiAddress][yeniId]=ReferansBilgi(yeniId,_referansBilgi.referansAdres,_referansBilgi.onayRedTarih,_referansBilgi.aciklama,_referansBilgi.pozisyon,ReferansDurum.OnayBekliyor);
         
           
            emit ReferansTalepEtLog(yeniId,_kisiAddress, _referansBilgi.referansAdres, _referansBilgi.durum);
        }
       
       
       function onayRedReferans(address _kisiAddress, uint referansId, bool accepted,string memory aciklama)  public {
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             require(kisiler[msg.sender].durum,"Referans Kisi mevcut degil");
          
            
        require(referansBilgiListesi[_kisiAddress][referansId].referansAdres==msg.sender,
        "Yalnizca kendinize atanan belgeye onay/red verebilirsiniz"
        );

        require(referansBilgiListesi[_kisiAddress][referansId].durum==ReferansDurum.OnayBekliyor,
        "Referansin yeni olusturulmus durumda olmasi gerekir"
        );
           referansBilgiListesi[_kisiAddress][referansId].aciklama=aciklama;
           referansBilgiListesi[_kisiAddress][referansId].onayRedTarih=block.timestamp;
        if(accepted){
           referansBilgiListesi[_kisiAddress][referansId].durum=ReferansDurum.Onaylandi;
        }
        else{
            referansBilgiListesi[_kisiAddress][referansId].durum=ReferansDurum.Reddedildi;          
        }
           
           emit ReferansOnayRedLog(referansId,_kisiAddress, msg.sender,accepted,block.timestamp);
        }

}