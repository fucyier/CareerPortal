// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";

contract KursBilgileri is BaseContract{
  uint public id;

    struct KursBilgi {
         uint id;
         address kursAdres;
         uint basTarih;
         uint bitTarih;
         uint8 sure;
         string egitimAdi;
        }
        mapping(address=>mapping(uint=>KursBilgi)) public kursBilgiListesi;



        event KursEklendiLog(address _kursAdres,uint _basTarih, uint _bitTarih,uint8  _sure);
        event KursGuncellendiLog(address _kursAdres,uint _basTarih, uint _bitTarih,uint8  _sure);

         function ekleKursBilgi(address _kisiAddress, KursBilgi memory _kursBilgi)  public sadeceKurs{
             require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
             uint yeniId=id++;
             kursBilgiListesi[_kisiAddress][yeniId].kursAdres=_kursBilgi.kursAdres;
             kursBilgiListesi[_kisiAddress][yeniId].basTarih=_kursBilgi.basTarih;
             kursBilgiListesi[_kisiAddress][yeniId].bitTarih=_kursBilgi.bitTarih;
             kursBilgiListesi[_kisiAddress][yeniId].sure=_kursBilgi.sure;
             kursBilgiListesi[_kisiAddress][yeniId].egitimAdi=_kursBilgi.egitimAdi;
            
           
            emit KursEklendiLog(_kursBilgi.kursAdres, _kursBilgi.basTarih, _kursBilgi.bitTarih, _kursBilgi.sure);
        }
          function guncelleKursBilgi(address _kisiAddress, KursBilgi memory _kursBilgi)  public sadeceKurs returns(uint){
                require(kisiler[_kisiAddress].durum,"Kisi mevcut degil");
                
             kursBilgiListesi[_kisiAddress][_kursBilgi.id].kursAdres=_kursBilgi.kursAdres;
             kursBilgiListesi[_kisiAddress][_kursBilgi.id].basTarih=_kursBilgi.basTarih;
             kursBilgiListesi[_kisiAddress][_kursBilgi.id].bitTarih=_kursBilgi.bitTarih;
             kursBilgiListesi[_kisiAddress][_kursBilgi.id].sure=_kursBilgi.sure;
             kursBilgiListesi[_kisiAddress][_kursBilgi.id].egitimAdi=_kursBilgi.egitimAdi;
              
              emit KursGuncellendiLog(_kursBilgi.kursAdres, _kursBilgi.basTarih, _kursBilgi.bitTarih, _kursBilgi.sure);
                return    _kursBilgi.id;

        }



}