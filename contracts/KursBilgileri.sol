// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";

contract KursBilgileri is BaseContract{
  uint public id;

    struct KursBilgi {
         uint id;
         address talepEdilenKurum;
         uint basTarih;
         uint bitTarih;
         uint8 sure;
         string egitimAdi;
         Onay onayBilgi;
        }
        mapping(address=>mapping(uint=>KursBilgi)) public kursBilgiListesi;



        event KursEklendiLog(address _kisiAddress,uint _basTarih, uint _bitTarih,uint8  _sure);
        event KursGuncellendiLog(address _kisiAddress,uint _basTarih, uint _bitTarih,uint8  _sure);
          event KursTalepEdildiLog(address _talepEdilenKurum,uint _basTarih, uint _bitTarih,uint8  _sure);

         function ekleKursBilgi(address _kisiAddress,  uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public sadeceKurs{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;

             kursBilgiListesi[_kisiAddress][yeniId].basTarih=basTarih;
             kursBilgiListesi[_kisiAddress][yeniId].bitTarih=bitTarih;
             kursBilgiListesi[_kisiAddress][yeniId].sure=sure;
             kursBilgiListesi[_kisiAddress][yeniId].egitimAdi=egitimAdi;
             kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
             kursBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
            emit KursEklendiLog(_kisiAddress, basTarih, bitTarih, sure);
        }
          function guncelleKursBilgi(address _kisiAddress, uint _kursBilgiId, uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public sadeceKurs returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                

             kursBilgiListesi[_kisiAddress][_kursBilgiId].basTarih=basTarih;
             kursBilgiListesi[_kisiAddress][_kursBilgiId].bitTarih=bitTarih;
             kursBilgiListesi[_kisiAddress][_kursBilgiId].sure=sure;
             kursBilgiListesi[_kisiAddress][_kursBilgiId].egitimAdi=egitimAdi;
       
             kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
             kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.zaman=block.timestamp;
             kursBilgiListesi[_kisiAddress][_kursBilgiId].onayBilgi.adres=msg.sender;

              emit KursGuncellendiLog(_kisiAddress, basTarih, bitTarih, sure);
                return    _kursBilgiId;

        }
  function talepEtKursBilgi(address _talepEdilenKurum,  uint basTarih, uint bitTarih, uint8 sure, string memory egitimAdi) public sadeceKisi{
             require(kisiler[msg.sender].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             kursBilgiListesi[msg.sender][yeniId].talepEdilenKurum=_talepEdilenKurum;
             kursBilgiListesi[msg.sender][yeniId].basTarih=basTarih;
             kursBilgiListesi[msg.sender][yeniId].bitTarih=bitTarih;
             kursBilgiListesi[msg.sender][yeniId].sure=sure;
             kursBilgiListesi[msg.sender][yeniId].egitimAdi=egitimAdi;
             kursBilgiListesi[msg.sender][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;

            emit KursEklendiLog(_talepEdilenKurum, basTarih, bitTarih, sure);
        }


}