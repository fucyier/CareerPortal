// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";


contract NitelikBilgileri is BaseProperties{

  uint public id;
  BaseContract baseContract;

    struct NitelikBilgi {
         uint id;
         address talepEdilenKurum;
         uint nitelikKodu;
         string aciklama;
         Seviye seviye;
         Onay onayBilgi;
        }

        mapping(address=>mapping(uint=>NitelikBilgi)) public nitelikBilgiListesi;
 mapping(address=>NitelikBilgi[]) public nitelikBilgiListesi2;

        event NitelikEklendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);
        event NitelikGuncellendiLog(address _onayKurumAdres,uint _tarih, uint _nitelikKodu);
         event NitelikTalepEdildiLog(address _talepEdilenKurum,uint _tarih, uint _nitelikKodu);

    constructor(address baseAddress)  {
        baseContract=BaseContract(baseAddress);
    }

     modifier _yetkiliPaydas{
      require(baseContract.isKurs(msg.sender)||baseContract.isKamuKurumu(msg.sender)||baseContract.isFirma(msg.sender)||baseContract.isSertifikaMerkezi(msg.sender),
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

         function ekleNitelikBilgi(address _kisiAddress, uint nitelikKodu, string memory aciklama, Seviye seviye)  public _yetkiliPaydas{
             require(baseContract.isKisi(_kisiAddress),"Kisi bulunamadi");
             uint yeniId=id++;

             nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][yeniId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
           
            emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
        }

 function ekleNitelikBilgi2(address _kisiAddress, uint nitelikKodu, string memory aciklama, Seviye seviye)  public _yetkiliPaydas{
             require(baseContract.isKisi(_kisiAddress),"Kisi bulunamadi");
             uint yeniId=id++;

            NitelikBilgi memory nb= NitelikBilgi({
              id:yeniId,
              talepEdilenKurum:address(0),
              nitelikKodu:nitelikKodu,
              aciklama:aciklama,
              seviye:seviye,
              onayBilgi:Onay(block.timestamp,msg.sender,OnayDurum.Onaylandi)
            });

          nitelikBilgiListesi2[_kisiAddress].push(nb);
            emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
        }
         function inspect(address key) public view returns(NitelikBilgi[] memory) {
        return nitelikBilgiListesi2[key];
    }
    
    function inspectLength(address key) public view returns(uint) {
        return nitelikBilgiListesi2[key].length;
    }
    
    function inspectRecord(address key, uint record) public view returns(NitelikBilgi memory) {
        return nitelikBilgiListesi2[key][record];
    }

          function guncelleNitelikBilgi(address _kisiAddress,uint nitelikBilgiId, uint nitelikKodu, string memory aciklama, Seviye seviye)  public _yetkiliPaydas returns(uint){
                require(baseContract.isKisi(_kisiAddress),"Kisi bulunamadi");

             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.adres=msg.sender;     
             nitelikBilgiListesi[_kisiAddress][nitelikBilgiId].onayBilgi.zaman=block.timestamp;
            
             emit NitelikGuncellendiLog(msg.sender, block.timestamp, nitelikKodu);
             return    nitelikBilgiId;

        }

  function talepEtNitelikBilgi(address _kisiAddress,address _talepEdilenKurum, uint nitelikKodu, string memory aciklama, Seviye seviye)  public {
             require(baseContract.isKisi(_kisiAddress),"Student not exists");
             uint yeniId=id++;

             nitelikBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum=_talepEdilenKurum;
             nitelikBilgiListesi[_kisiAddress][yeniId].nitelikKodu=nitelikKodu;
             nitelikBilgiListesi[_kisiAddress][yeniId].aciklama=aciklama;
             nitelikBilgiListesi[_kisiAddress][yeniId].seviye=seviye;
             nitelikBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;
           
            emit NitelikEklendiLog(msg.sender, block.timestamp, nitelikKodu);
        }

}